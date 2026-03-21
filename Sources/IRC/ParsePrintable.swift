import Parsing

public protocol ParsePrintable {
    associatedtype Parser: Parsing.ParserPrinter<Substring, Self>
    static var parser: Parser { get }
}

extension ParsePrintable {
    public init(parsing input: Substring) throws {
        self = try Self.parser.parse(input)
    }
    
    var printed: Substring {
        get throws {
            try Self.parser.print(self)
        }
    }
}
