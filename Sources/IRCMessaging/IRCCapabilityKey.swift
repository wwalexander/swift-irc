import Parsing

public struct IRCCapabilityKey: Sendable, Equatable, Hashable {
    public var vendor: IRCMessageTagVendor?
    public var name: IRCCapabilityName
    
    public init(vendor: IRCMessageTagVendor? = nil, _ name: IRCCapabilityName) {
        self.vendor = vendor
        self.name = name
    }
}

extension IRCCapabilityKey: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(vendor:_:))) {
            Optionally {
                IRCMessageTagVendor.parser
                "/"
            }
            IRCCapabilityName.parser
        }
    }
}

extension IRCCapabilityKey: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        self.init(.init(stringLiteral: value))
    }
}
