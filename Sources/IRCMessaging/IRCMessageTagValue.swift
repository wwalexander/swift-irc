import Parsing

public struct IRCMessageTagValue: Sendable, Equatable {
    public let escaped: String
}

extension IRCMessageTagValue: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(escaped:)))) {
            Prefix(while: isCharacter)
        }
    }
    
    private static func isCharacter(_ character: Character) -> Bool {
        character != "\0" &&
        character != "\r" &&
        character != "\n" &&
        character != ";" &&
        character != " "
    }
}

extension IRCMessageTagValue: LosslessStringConvertible {
    public init?(_ description: String) {
        try! self.init(parsing: Self.replacements.reduce(into: description[...]) { partialResult, replacement in
            partialResult.replace(replacement.key, with: replacement.value)
        })
    }
    
    public var description: String {
        Self.replacements.reversed().reduce(into: escaped) { partialResult, replacement in
            partialResult.replace(replacement.value, with: replacement.key)
        }
    }
    
    static let replacements: KeyValuePairs = [
        #"\"#: #"\\"#,
        ";": #"\:"#,
        " ": #"\s"#,
        "\r": #"\r"#,
        "\n": #"\n"#,
    ]
}

extension IRCMessageTagValue: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        self.init(value)!
    }
}

