import Parsing

public struct Tag: Sendable, Equatable, ParsePrintable {
    public var key: TagKey
    public var value: TagValue?
    
    public init(key: TagKey, value: TagValue? = nil) {
        self.key = key
        self.value = value
    }
    
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            TagKey.parser
            Optionally {
                "="
                TagValue.parser
            }
        }
    }
}

extension Tag: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        self.init(key: .init(stringLiteral: value))
    }
}
