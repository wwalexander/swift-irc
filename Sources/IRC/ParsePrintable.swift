import Parsing

public protocol ParsePrintable {
    associatedtype Parser: Parsing.ParserPrinter<Substring, Self>
    static var parser: Parser { get }
}

extension ParsePrintable {
    public init<C>(parsing input: C) throws
    where C : Collection, Parser.Input == C.SubSequence {
        self = try Self.parser.parse(input)
    }
    
    public var printed: Parser.Input {
        get throws {
            try Self.parser.print(self)
        }
    }
}
