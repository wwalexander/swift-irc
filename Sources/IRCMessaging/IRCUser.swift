import Parsing

public struct IRCUser: Sendable, Equatable {
    public let rawValue: String
}

extension IRCUser: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(rawValue:)))) {
            Prefix(1..., while: isCharacter)
        }
    }
    
    private static func isCharacter(_ character: Character) -> Bool {
        character != "@" && // Not in specification, but needed to prevent ambiguity
        character != "\0" &&
        character != "\r" &&
        character != "\n" &&
        character != " "
    }
}

extension IRCUser: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
    }
}
