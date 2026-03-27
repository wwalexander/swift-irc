import Parsing

public struct CapabilityChange: Sendable, Equatable {
    public var disable: Bool
    public var capability: Capability
    
    public init(disable: Bool = false, _ capability: Capability) {
        self.disable = disable
        self.capability = capability
    }
    
    public static func enable(_ capability: Capability) -> Self {
        .init(disable: false, capability)
    }
    
    public static func disable(_ capability: Capability) -> Self {
        .init(disable: true, capability)
    }
    
    public func apply(to set: inout some SetAlgebra<Capability>) {
        if disable {
            set.remove(capability)
        } else {
            set.insert(capability)
        }
    }
}

extension CapabilityChange: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            "-".map { true }.replaceError(with: false)
            Capability.parser
        }
    }
}

extension CapabilityChange: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        self = .enable(.init(stringLiteral: value))
    }
}
