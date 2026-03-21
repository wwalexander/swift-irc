import Parsing

public struct Capability: Sendable, Equatable {
    public var vendor: Vendor?
    public var name: CapabilityName
    
    public init(vendor: Vendor? = nil, name: CapabilityName) {
        self.vendor = vendor
        self.name = name
    }
}

extension Capability: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(vendor:name:))) {
            Optionally {
                Vendor.parser
                "/"
            }
            CapabilityName.parser
        }
    }
}

public struct CapabilityName: Sendable {
    let value: String
}

extension CapabilityName: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(value:)))) {
            Consumed {
                Prefix(1, while: \.isCapabilityNameFirst)
                Prefix(0...)
            }
        }
    }
}

extension CapabilityName: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value.caseInsensitiveCompare(rhs.value) == .orderedSame
    }
}

extension CapabilityName: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value[...])
    }
}

fileprivate extension Character {
    var isCapabilityNameFirst: Bool {
        self != "-"
    }
}
