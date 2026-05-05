import Parsing

public struct IRCMessage: Sendable, Equatable {
    public var tags: IRCMessageTags?
    public var source: IRCMessageSource?
    public var command: IRCCommand
    public var parameters: IRCMessageParameters
    
    public init(
        tags: IRCMessageTags? = nil,
        source: IRCMessageSource? = nil,
        _ command: IRCCommand,
        _ parameters: IRCMessageParameters = .init()
    ) {
        self.tags = tags
        self.source = source
        self.command = command
        self.parameters = parameters
    }
}

extension IRCMessage: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            Optionally {
                "@"
                IRCMessageTags.parser
                " "
            }
            Optionally {
                ":"
                IRCMessageSource.parser
                " "
            }
            IRCCommand.parser
            IRCMessageParameters.parser
        }
    }
}





