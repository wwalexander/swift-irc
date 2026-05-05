import Parsing

public struct IRCCapability: Sendable, Equatable, Hashable {
    public let key: IRCCapabilityKey
    public let value: IRCCapabilityValue?
    
    public init(_ key: IRCCapabilityKey, _ value: IRCCapabilityValue? = nil) {
        self.key = key
        self.value = value
    }
}

extension IRCCapability: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(_:_:))) {
            IRCCapabilityKey.parser
            Optionally {
                "="
                IRCCapabilityValue.parser
            }
        }
    }
}

extension IRCCapability: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(.init(stringLiteral: value))
    }
}

/// https://ircv3.net/registry#capabilities
public extension IRCCapability {
    static let accountNotify: Self = "account-notify"
    // TODO: Remaining capabilities
}
