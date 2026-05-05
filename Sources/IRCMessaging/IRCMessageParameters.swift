import Parsing

public struct IRCMessageParameters: Sendable, Equatable {
    public var middle: [MiddleParameter]
    public var trailing: TrailingParameter?
    
    public init(middle: [MiddleParameter], trailing: TrailingParameter?) {
        self.middle = middle
        self.trailing = trailing
    }
    
    public init(_ middle: MiddleParameter..., trailing: TrailingParameter? = nil) {
        self.init(middle: middle, trailing: trailing)
    }
}

extension IRCMessageParameters: RandomAccessCollection {
    public typealias Index = [MiddleParameter].Index
    
    public var startIndex: Index {
        middle.startIndex
    }
    
    public var endIndex: Index {
        middle.endIndex.advanced(by: 1)
    }
    
    public func index(after i: Index) -> Index {
        middle.index(after: i)
    }
    
    public func index(before i: Index) -> Index {
        middle.index(before: i)
    }
    
    public subscript(position: Index) -> String {
        if middle.indices.contains(position) {
            .init(try! middle[position].printed)
        } else {
            .init(try! trailing!.printed)
        }
    }
}

extension IRCMessageParameters: ParsePrintable {
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

public struct MiddleParameter: Sendable, Equatable {
    let value: String
}

extension MiddleParameter: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(value:)))) {
            Consumed {
                Prefix(1, while: isStartCharacter)
                Prefix(while: isCharacter)
            }
        }
    }
    
    private static func isStartCharacter(_ character: Character) -> Bool {
        character.isParameter
    }
    
    private static func isCharacter(_ character: Character) -> Bool {
        character == ":" ||
        character.isParameter
    }
}

extension MiddleParameter: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
    }
}

public struct TrailingParameter: Sendable, Equatable {
    let value: String
}

extension TrailingParameter: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(value:)))) {
            Prefix(while: isCharacter)
        }
    }
    
    private static func isCharacter(_ character: Character) -> Bool {
        character == ":" ||
        character == " " ||
        character.isParameter
    }
}

extension TrailingParameter: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
    }
}


fileprivate extension Character {
    var isParameter: Bool {
        self != "\0" &&
        self != "\r" &&
        self != "\n" &&
        self != ":" &&
        self != " "
    }
}
