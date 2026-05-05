import Parsing
import IRC

public struct IRCNickname: Sendable, Equatable {
    let value: String
}

extension IRCNickname: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(value:)))) {
            Consumed {
                Prefix(1, while: Self.isFirstCharacter)
                Prefix(while: Self.isCharacter)
            }
        }
    }
    
    private static func isCharacter(_ character: Character) -> Bool {
        character != " " &&
        character != "," &&
        character != "*" &&
        character != "?" &&
        character != "!" &&
        character != "@" &&
        character != "\0" &&
        character != "\r" &&
        character != "\n" &&
        character != " "
    }
    
    private static func isFirstCharacter(_ character: Character) -> Bool {
        isCharacter(character) &&
        character != "$" &&
        character != ":" &&
        !isChannelTypeCharacter(character) &&
        !isChannelMembershipPrefixCharacter(character)
    }
    
    private static func isChannelTypeCharacter(_ character: Character) -> Bool {
        IRCChannelType.allCases.contains { character == $0.rawValue }

    }
    
    private static func isChannelMembershipPrefixCharacter(_ character: Character) -> Bool {
        IRCChannelMembership.allCases.contains { character == $0.rawValue }
    }
}

extension IRCNickname: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
    }
}
