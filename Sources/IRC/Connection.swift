import Foundation
import Network
import AsyncAlgorithms

public actor Connection {
    private let connection: NWConnection
    
    public init(
        host: String,
        port: Int? = nil,
        tls: Bool = true
    ) {
        connection = .init(
            host: .init(host),
            port: .init(integerLiteral: .init(port ?? (tls ? 6697 : 6667))),
            using: tls ? .tls : .tcp
        )
        
        Task {
            let messages = AsyncThrowingStream(Data.self) { continuation in
                let connection = connection
                
                @Sendable func yield() {
                    connection.receive(minimumIncompleteLength: 1, maximumLength: 8191) { content, _, isComplete, error in
                        if let content, !content.isEmpty {
                            continuation.yield(content)
                        }
                        
                        if let error {
                            continuation.yield(with: .failure(error))
                        }
                        
                        if isComplete {
                            continuation.finish()
                            return
                        }
                        
                        yield()
                    }
                }
                
                yield()
            }
            .flatMap { $0.async }
            .lines
            .map(Message.init(parsing:))
            
            for try await message in messages {
                try await receive(message: message)
            }
        }
    }
    
    func send(_ message: Message) async throws {
        let content = Data("\(try Message.parser.print(message))\r\n".utf8)
        
        return try await withCheckedThrowingContinuation { continuation in
            connection.send(content: content, completion: .contentProcessed{ error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            })
        }
    }
    
    private var supportedCapabilities: Set<Capability> = []
    private var enabledCapabilities: Set<Capability> = []
    
    func receive(message: Message) async throws {
        switch message.command {
        case .client(.cap):
            print(try message.printed)
            var parameters = message.parameters[...]
            
            guard let nick = parameters.popFirst() else {
                return
            }
            
            switch parameters.popFirst()?.uppercased() {
            case "LS":
                let more: Bool
                
                if parameters.first == "*" {
                    more = true
                    parameters.removeFirst()
                } else {
                    more = false
                }
                
                guard let lastParameter = parameters.last else {
                    return
                }
                
                supportedCapabilities.formUnion(try Capabilities(parsing: lastParameter))
                
                if !more {
                    try await send(.init(.client(.cap), .init("END")))
                }
            case "LIST":
                let more: Bool

                if parameters.first == "*" {
                    more = true
                    parameters.removeFirst()
                } else {
                    more = false
                }

                guard let lastParameter = parameters.last else {
                    return
                }
                
                enabledCapabilities.formUnion(try Capabilities(parsing: lastParameter))
            case "ACK":
                guard let lastParameter = parameters.last else {
                    return
                }
                
                try CapabilityChanges(parsing: lastParameter).apply(to: &enabledCapabilities)
            case "NAK":
                guard let lastParameter = parameters.last else {
                    return
                }
                
                enabledCapabilities.subtract(try Capabilities(parsing: lastParameter) )
            case "NEW":
                guard let lastParameter = parameters.last else {
                    return
                }
                
                supportedCapabilities.formUnion(try Capabilities(parsing: lastParameter))
            case "DEL":
                guard let lastParameter = parameters.last else {
                    return
                }
                
                supportedCapabilities.subtract(try Capabilities(parsing: lastParameter))
            default:
                break
            }
        default:
            print(try! Message.parser.print(message))
            break
        }
    }
}

extension Connection {
    public func start() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            connection.stateUpdateHandler = { state in
                switch state {
                case .ready: continuation.resume()
                case let .failed(error): continuation.resume(throwing: error)
                default: break
                }
            }
            
            connection.start(queue: .global())
        }
    }
    
    public func stop() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            connection.stateUpdateHandler = { state in
                switch state {
                case .cancelled: continuation.resume()
                case let .failed(error): continuation.resume(throwing: error)
                default: break
                }
            }
            
            connection.cancel()
        }
    }
}

extension Connection {
    public func register(
        password: TrailingParameter? = nil,
        nickname: TrailingParameter,
        userName: MiddleParameter,
        realName: TrailingParameter
    ) async throws {
        if let password {
            try await pass(password: password)
        }
        
        try await startNegotiatingCapabilities()
        try await nick(nickname: nickname)
        try await user(name: userName, realName: realName)
        // TODO: SASL (if negotiated)
    }
}

extension Connection {
    public func pass(password: TrailingParameter) async throws {
        try await send(.init(.client(.pass), .init(trailing: password)))
    }
    
    public func nick(nickname: TrailingParameter) async throws {
        try await send(.init(.client(.nick), .init(trailing: nickname)))
    }
    
    public func user(name: MiddleParameter, realName: TrailingParameter) async throws {
        try await send(.init(.client(.user), .init(name, "0", "*", trailing: realName)))
    }
    
    func startNegotiatingCapabilities() async throws {
        try await send(.init(.client(.cap), .init("LS", "302")))
    }
}

