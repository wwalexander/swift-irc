import Parsing

public struct CapabilityName: Sendable, Equatable {
    let rawValue: String
}

extension CapabilityName: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(rawValue:))) {
            Parse(.string) {
                Consumed {
                    Prefix(1, while: \.isCapabilityNameFirst)
                    Prefix(while: \.isCapabilityName)
                }
            }
        }
    }
}

fileprivate extension Character {
    var isCapabilityNameFirst: Bool {
        isCapabilityName &&
        self != "-"
    }
    
    var isCapabilityName: Bool {
        self != "=" &&
        self != " "
    }
}

extension CapabilityName: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue.lowercased())
    }
}

extension CapabilityName: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
    }
}
