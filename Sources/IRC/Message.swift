import Parsing

public struct Message: Sendable, Equatable {
    public var tags: Tags?
    public var source: Source?
    public var command: Command
    public var parameters: Parameters
    
    public init(
        tags: Tags? = nil,
        source: Source? = nil,
        _ command: Command,
        _ parameters: Parameters = .init()
    ) {
        self.tags = tags
        self.source = source
        self.command = command
        self.parameters = parameters
    }
}

extension Message: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            Optionally {
                "@"
                Tags.parser
                " "
            }
            Optionally {
                ":"
                Source.parser
                " "
            }
            Command.parser
            Parameters.parser
        }
    }
}





