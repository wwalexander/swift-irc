import Parsing

public enum Command: Sendable, Equatable {
    case client(ClientCommand)
    case numeric(NumericCommand)
}

extension Command: ParsePrintable, RawRepresentable, ExpressibleByStringLiteral {
    public static var parser: some ParserPrinter<Substring, Self> {
        OneOf {
            ClientCommand.parser.map(.case(client))
            NumericCommand.parser.map(.case(numeric))
        }
    }
}

public struct ClientCommand: Sendable, Equatable {
    let unchecked: String
}

extension ClientCommand: ParsePrintable, RawRepresentable, ExpressibleByStringLiteral {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init))) {
            Parsing.Prefix(1...) {
                $0.isLetter
            }
        }
    }
}

public struct NumericCommand: Sendable, Equatable {
    let unchecked: Int
}

extension NumericCommand: RawRepresentable {
    public init?(rawValue: Int) {
        guard (0...999).contains(rawValue) else {
            return nil
        }
        
        self.init(unchecked: rawValue)
    }
    
    public var rawValue: Int {
        unchecked
    }
}

extension NumericCommand: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(rawValue: value)!
    }
}

extension NumericCommand: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(unchecked:))) {
            Digits(3)
        }
    }
}
