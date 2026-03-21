import Parsing

public struct User: Sendable, Equatable, ParsePrintable {
    let string: String
    
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(string:)))) {
            Prefix(1..., while: \.isUser)
        }
    }
}

extension User: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value[...])
    }
}

fileprivate extension Character {
    var isUser: Bool {
        self != "@" && // Not in specification, but needed to prevent ambiguity
        self != "\0" &&
        self != "\r" &&
        self != "\n" &&
        self != " "
    }
}
