import Parsing

public struct Capability: Sendable, Equatable, Hashable {
    public let key: CapabilityKey
    public let value: CapabilityValue?
    
    public init(_ key: CapabilityKey, _ value: CapabilityValue? = nil) {
        self.key = key
        self.value = value
    }
}

extension Capability: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(_:_:))) {
            CapabilityKey.parser
            Optionally {
                "="
                CapabilityValue.parser
            }
        }
    }
}

extension Capability: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(.init(stringLiteral: value))
    }
}

/// https://ircv3.net/registry#capabilities
public extension Capability {
    static let accountNotify: Self = "account-notify"
    // TODO: Remaining capabilities
}
