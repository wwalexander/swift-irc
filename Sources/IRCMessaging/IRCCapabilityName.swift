import Parsing

public struct IRCCapabilityName: Sendable, Equatable {
    let rawValue: String
}

extension IRCCapabilityName: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(rawValue:))) {
            Parse(.string) {
                Consumed {
                    Prefix(1, while: isFirstCharacter)
                    Prefix(while: isCharacter)
                }
            }
        }
    }
    
    private static func isFirstCharacter(_ character: Character) -> Bool {
        isCharacter(character) &&
        character != "-"
    }
    
    private static func isCharacter(_ character: Character) -> Bool {
        character != "=" &&
        character != " "
    }
}

extension IRCCapabilityName: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue.lowercased())
    }
}

extension IRCCapabilityName: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
    }
}
