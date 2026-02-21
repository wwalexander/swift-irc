import Parsing

public struct Tag: Sendable, Equatable {
    public var key: Key
    public var value: EscapedValue?
    
    public init(key: Key, value: EscapedValue? = nil) {
        self.key = key
        self.value = value
    }
}

extension Tag: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            Key.parser
            Optionally {
                "="
                EscapedValue.parser
            }
        }
    }
}
