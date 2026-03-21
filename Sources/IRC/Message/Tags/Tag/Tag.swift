import Parsing

public struct Tag: Sendable, Equatable, ParsePrintable {
    public var key: Key
    public var value: Value?
    
    public init(key: Key, value: Value? = nil) {
        self.key = key
        self.value = value
    }
    
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            Key.parser
            Optionally {
                "="
                Value.parser
            }
        }
    }
}

extension Tag: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        self.init(key: .init(stringLiteral: value))
    }
}
