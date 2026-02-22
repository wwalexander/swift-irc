import Foundation
import Network

public final class Client {
    let messages: AsyncThrowingStream<Message, Error>
    
    public init(
        host: NWEndpoint.Host,
        port: NWEndpoint.Port? = nil,
        tls: Bool = true
    ) {
       messages = AsyncThrowingStream(Message.self) { continuation in
            let chunks = AsyncThrowingStream(Data.self) { continuation in
                let connection = NWConnection(
                    host: host,
                    port: port ?? (tls ? 6697 : 6667),
                    using: tls ? .tls : .tcp
                )
                
                continuation.onTermination = { _ in
                    connection.cancel()
                }
                
                @Sendable func receive() {
                    connection.receive(
                        minimumIncompleteLength: 1,
                        maximumLength: 512
                    ) { content, _, isComplete, error in
                        
                        if let error {
                            continuation.finish(throwing: error)
                            return
                        }
                        
                        if let content, !content.isEmpty {
                            continuation.yield(content)
                        }
                        
                        if isComplete {
                            continuation.finish()
                            return
                        }
                        
                        receive()
                    }
                }

                connection.stateUpdateHandler = { state in
                    switch state {
                    case .ready:
                        receive()
                    case .failed(let error):
                        continuation.finish(throwing: error)
                    case .cancelled:
                        continuation.finish()
                    default:
                        break
                    }
                }

                connection.start(queue: .global())
            }
            
            Task {
                var buffer = Data()
                
                do {
                    for try await chunk in chunks {
                        buffer.append(chunk)
                        
                        while let range = buffer.range(of: .init("\r\n".utf8)) {
                            let data = buffer.subdata(in: buffer.startIndex..<range.lowerBound)
                            let line = String(data: data, encoding: .utf8)! // TODO: Handle bad encoding
                            let message = try Message.parser.parse(line)
                            continuation.yield(message)
                            buffer.removeSubrange(..<range.upperBound)
                        }
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
                
                continuation.finish()
                
            }
        }
    }
}
