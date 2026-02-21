import Parsing

public struct KeyName: Sendable, Equatable {
    let unchecked: String
}

extension KeyName: ParsePrintable, RawRepresentable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(unchecked:)))) {
            Parsing.Prefix(1...) {
                $0.isLetter || $0.isNumber || $0 == "-"
            }
        }
    }
}

extension KeyName: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)!
    }
}
