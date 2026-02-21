import Parsing

public struct Params: Sendable, Equatable {
    public var middle: [MiddleParam]
    public var trailing: TrailingParam?
    
    public init(
        middle: [MiddleParam] = [],
        trailing: TrailingParam? = nil
    ) {
        self.middle = middle
        self.trailing = trailing
    }
}

extension Params: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(middle:trailing:))) {
            Many {
                " "
                MiddleParam.parser
            }
            Optionally {
                " :"
                TrailingParam.parser
            }
        }
    }
}

public struct MiddleParam: Sendable, Equatable {
    let unchecked: String
}

extension MiddleParam: ParsePrintable, RawRepresentable, ExpressibleByStringLiteral {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(unchecked:)))) {
            Consumed {
                Parsing.Prefix(1, while: \.isMiddleParamFirst)
                Parsing.Prefix(while: \.isMiddleParam)
            }
        }
    }
}

extension Character {
    fileprivate var isMiddleParamFirst: Bool {
        isMiddleParam && self != ":"
    }
    
    fileprivate var isMiddleParam: Bool {
        self != " " && self != "\0" && self != "\r" && self != "\n"
    }
}

public struct TrailingParam: Sendable, Equatable {
    let unchecked: String
}

extension TrailingParam: ParsePrintable, RawRepresentable, ExpressibleByStringLiteral {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(unchecked:)))) {
            Consumed {
                Parsing.Prefix {
                    $0 != "\0" && $0 != "\r" && $0 != "\n"
                }
            }
        }
    }
}
