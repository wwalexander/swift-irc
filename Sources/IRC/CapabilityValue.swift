import Parsing

public struct CapabilityValue: Sendable, Equatable, Hashable {
    public let rawValue: String
}

extension CapabilityValue: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(rawValue:))) {
            Parse(.string) {
                Prefix(while: \.isCapabilityValue)
            }
        }
        
    }
}

fileprivate extension Character {
    var isCapabilityValue: Bool {
        self != " "
    }
}

extension CapabilityValue: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
    }
}

