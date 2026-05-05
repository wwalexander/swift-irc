import Parsing

public struct IRCMessageTagKeyName: Sendable, Equatable {
    let value: String
}

extension IRCMessageTagKeyName: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(value:)))) {
            Prefix(1..., while: isCharacter)
        }
    }
    
    private static func isCharacter(_ character: Character) -> Bool {
        character.isLetter ||
        character.isNumber ||
        character == "-" ||
        character == "."
    }
}

extension IRCMessageTagKeyName: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
    }
}
