import Parsing

public protocol Parsable<Input> {
    associatedtype Input
    associatedtype Parser: Parsing.Parser<Input, Self>
    static var parser: Parser { get }
}

extension Parsable where Self: ExpressibleByStringLiteral, Input == Substring {
    public init(stringLiteral value: String) {
        self = try! Self.parser.parse(value)
    }
}

public protocol ParsePrintable: Parsable where Parser: ParserPrinter {}

extension ParsePrintable where Self: RawRepresentable, RawValue == String, Input == Substring {
    public init?(rawValue: RawValue) {
        guard let output = try? Self.parser.parse(rawValue) else {
            return nil
        }
        
        self = output
    }
    
    public var rawValue: RawValue {
        .init(try! Self.parser.print(self))
    }
}

