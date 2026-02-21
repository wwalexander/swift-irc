import Parsing

public struct Message: Sendable, Equatable {
    public var tags: Tags?
    public var prefix: Prefix?
    public var command: Command
    public var params: Params
    
    public init(
        tags: Tags? = nil,
        prefix: Prefix? = nil,
        command: Command,
        params: Params = .init()
    ) {
        self.tags = tags
        self.prefix = prefix
        self.command = command
        self.params = params
    }
}

extension Message: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(tags:prefix:command:params:))) {
            Optionally {
                "@"
                Tags.parser
                " "
            }
            Optionally {
                ":"
                Prefix.parser
                " "
            }
            Command.parser
            Params.parser
        }
    }
}

