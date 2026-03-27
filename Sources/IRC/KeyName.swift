import Parsing

public struct KeyName: Sendable, Equatable {
    let value: String
}

extension KeyName: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(value:)))) {
            Prefix(1..., while: \.isKeyName)
        }
    }
}

fileprivate extension Character {
    var isKeyName: Bool {
        isLetter || isNumber || self == "-" || self == "."
    }
}

extension KeyName: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
    }
}
