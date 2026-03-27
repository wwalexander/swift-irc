import Parsing

public struct CapabilityKey: Sendable, Equatable, Hashable {
    public var vendor: Vendor?
    public var name: CapabilityName
    
    public init(vendor: Vendor? = nil, _ name: CapabilityName) {
        self.vendor = vendor
        self.name = name
    }
}

extension CapabilityKey: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(vendor:_:))) {
            Optionally {
                Vendor.parser
                "/"
            }
            CapabilityName.parser
        }
    }
}

extension CapabilityKey: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        self.init(.init(stringLiteral: value))
    }
}
