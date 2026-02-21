import Parsing

public struct Host: Sendable, Equatable {
    public let unchecked: String
}

extension Host: ParsePrintable, RawRepresentable, ExpressibleByStringLiteral {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(unchecked:)))) {
            Consumed {
                // TODO: Figure out how to allow single-name hosts without making Prefix parser nondeterministic
                Many(2...) {
                    Parsing.Prefix(1) {
                        $0.isLetter || $0.isNumber
                    }
                    Optionally {
                        Parsing.Prefix {
                            $0.isLetter || $0.isNumber || $0 == "-"
                        }
                    }
                    Parsing.Prefix {
                        $0.isLetter || $0.isNumber
                    }
                } separator: {
                    "."
                }
            }
        }
    }
}
