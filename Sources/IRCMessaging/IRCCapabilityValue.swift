import Parsing

public struct IRCCapabilityValue: Sendable, Equatable, Hashable {
    public let rawValue: String
}

extension IRCCapabilityValue: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(rawValue:))) {
            Parse(.string) {
                Prefix(while: isCharacter)
            }
        }
    }
    
    private static func isCharacter(_ character: Character) -> Bool {
        character != " "
    }
}


extension IRCCapabilityValue: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
    }
}

