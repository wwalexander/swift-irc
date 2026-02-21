import Parsing

public struct User: Sendable, Equatable {
    let unchecked: String
}

extension User: ParsePrintable, RawRepresentable, ExpressibleByStringLiteral {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init))) {
            Parsing.Prefix(1...) {
                $0 != " " && $0 != "\0" && $0 != "\r" && $0 != "\n"
            }
        }
    }
}
