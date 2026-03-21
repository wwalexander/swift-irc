import Parsing

public struct Parameters: Sendable, Equatable, ParsePrintable {
    public var middle: [MiddleParameter]
    public var trailing: TrailingParameter?
    
    public init(middle: [MiddleParameter], trailing: TrailingParameter? = nil) {
        self.middle = middle
        self.trailing = trailing
    }
    
    public init(_ middle: MiddleParameter..., trailing: TrailingParameter? = nil) {
        self.init(middle: middle, trailing: trailing)
    }
    
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            Many {
                " "
                MiddleParameter.parser
            }
            Optionally {
                " :"
                TrailingParameter.parser
            }
        }
    }
}

public struct MiddleParameter: Sendable, Equatable, ParsePrintable {
    let value: String
    
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(value:)))) {
            Consumed {
                Prefix(1, while: \.isMiddleParameterStart)
                Prefix(while: \.isMiddleParameter)
            }
        }
    }
}

extension MiddleParameter: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value[...])
    }
}

public struct TrailingParameter: Sendable, Equatable, ParsePrintable {
    let value: String
    
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(value:)))) {
            Prefix(while: \.isTrailingParameter)
        }
    }
}

extension TrailingParameter: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value[...])
    }
}


fileprivate extension Character {
    var isMiddleParameterStart: Bool {
        isParameter
    }
    
    var isMiddleParameter: Bool {
        self == ":" ||
        isParameter
    }
    
    var isTrailingParameter: Bool {
        self == ":" ||
        self == " " ||
        isParameter
    }
    
    var isParameter: Bool {
        self != "\0" &&
        self != "\r" &&
        self != "\n" &&
        self != ":" &&
        self != " "
    }
}
