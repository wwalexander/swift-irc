import Parsing

public struct IRCMessageTag: Sendable, Equatable, ParsePrintable {
    public var key: IRCMessageTagKey
    public var value: IRCMessageTagValue?
    
    public init(key: IRCMessageTagKey, value: IRCMessageTagValue? = nil) {
        self.key = key
        self.value = value
    }
    
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            IRCMessageTagKey.parser
            Optionally {
                "="
                IRCMessageTagValue.parser
            }
        }
    }
}

extension IRCMessageTag: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        self.init(key: .init(stringLiteral: value))
    }
}
