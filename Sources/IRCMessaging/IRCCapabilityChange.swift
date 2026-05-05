import Parsing

public struct IRCCapabilityChange: Sendable, Equatable {
    public var disable: Bool
    public var capability: IRCCapability
    
    public init(disable: Bool = false, _ capability: IRCCapability) {
        self.disable = disable
        self.capability = capability
    }
    
    public static func enable(_ capability: IRCCapability) -> Self {
        .init(disable: false, capability)
    }
    
    public static func disable(_ capability: IRCCapability) -> Self {
        .init(disable: true, capability)
    }
    
    public func apply(to set: inout some SetAlgebra<IRCCapability>) {
        if disable {
            set.remove(capability)
        } else {
            set.insert(capability)
        }
    }
}

extension IRCCapabilityChange: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            "-".map { true }.replaceError(with: false)
            IRCCapability.parser
        }
    }
}

extension IRCCapabilityChange: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        self = .enable(.init(stringLiteral: value))
    }
}
