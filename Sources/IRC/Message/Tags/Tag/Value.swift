import Parsing

public struct Value: Sendable, Equatable, ParsePrintable {
    let escaped: String
    
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(escaped:)))) {
            Prefix(while: \.isEscapedValue)
        }
    }
}

extension Value: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        self.init(value)!
    }
}

extension Value: LosslessStringConvertible {
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

fileprivate extension Character {
    var isEscapedValue: Bool {
        self != "\0" &&
        self != "\r" &&
        self != "\n" &&
        self != ";" &&
        self != " "
    }
}
