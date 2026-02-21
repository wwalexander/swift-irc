import NIO
import NIOTransportServices
import NIOExtras

public final class Client: Sendable {
    public let messages: AsyncThrowingStream<Message, Error>
    let channel: Channel

    public init(
        host: String,
        port: Int
    ) async throws {
        var continuation: AsyncThrowingStream<Message, Error>.Continuation!
        
        messages = AsyncThrowingStream {
            continuation = $0
        }
        
        channel = try await NIOTSConnectionBootstrap(group: NIOTSEventLoopGroup())
            .tlsOptions(.init())
            .channelInitializer { channel in
                channel.pipeline.addHandlers([
                    ByteToMessageHandler(LineBasedFrameDecoder()),
                    IRCMessageHandler(continuation: continuation)
                ])
            }
            .connect(host: host, port: port)
            .get()
    }
    
    public func send(message: Message) async throws {
        try await channel.writeAndFlush(channel.allocator.buffer(string: Message.parser.print(message) + "\r\n"))
    }
}

final class IRCMessageHandler: ChannelInboundHandler, Sendable {
    typealias InboundIn = ByteBuffer
    
    let continuation: AsyncThrowingStream<Message, Error>.Continuation
    
    init(continuation: AsyncThrowingStream<Message, Error>.Continuation) {
        self.continuation = continuation
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var buffer = unwrapInboundIn(data)

        guard let line = buffer.readString(length: buffer.readableBytes) else {
            return
        }
        
        do {
            continuation.yield(try Message.parser.parse(line))
        } catch {
            continuation.finish(throwing: error)
        }
    }
}
