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
            .map {
                try Message.parser.parse($0)
            }
            
            for try await message in messages {
                await receive(message: message)
            }
        }
    }
    
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
    
    func receive(message: Message) {
        switch message.command {
            
        default:
            print(try! Message.parser.print(message))
            break
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
    
    public func pass(password: TrailingParameter) async throws {
        try await send(.init(.pass,. init(trailing: password)))
    }
    
    public func nick(nickname: TrailingParameter) async throws {
        try await send(.init(.nick, .init(trailing: nickname)))
    }
    
    public func user(name: MiddleParameter, realName: TrailingParameter) async throws {
        try await send(.init(.user, .init(name, "0", "*", trailing: realName)))
    }
    
    public func register(
        password: TrailingParameter? = nil,
        nickname: TrailingParameter,
        userName: MiddleParameter,
        realName: TrailingParameter
    ) async throws {
        if let password {
            try await pass(password: password)
        }
        
        try await nick(nickname: nickname)
        try await user(name: userName, realName: realName)
        // TODO: Capability negotiation
        // TODO: SASL (if negotiated)
        try await send(.init(.cap, .init("END")))
    }
}
