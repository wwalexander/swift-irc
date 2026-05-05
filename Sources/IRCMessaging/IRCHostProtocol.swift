import Parsing

protocol IRCHostProtocol: ExpressibleByStringInterpolation, ParsePrintable {
    var rawValue: String { get }
    init(rawValue: String)
    static var minimumNames: Int { get }
}

extension IRCHostProtocol {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
    }
}

extension IRCHostProtocol {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(rawValue:)))) {
            Consumed {
                Many(minimumNames...) {
                    Prefix(1, while: isNameFirstOrLastCharacter)
                    Prefix(while: isNameCharacter)
                    /**
                     Technically, [RFC 952](https://datatracker.ietf.org/doc/html/rfc952#page-5) and [RFC 1123](https://datatracker.ietf.org/doc/html/rfc1123#page-13) dictate that a name must end with a letter or digit, but the parser below fails due to the first Prefix greedily consuming what should be the last character; it doesn't really matter for the purposes of a client anyways.
                     */
//                    Optionally {
//                        Prefix(while: \.isHostName)
//                        Prefix(1, while: \.isHostNameFirstOrLast)
//                    }
                } separator: {
                    "."
                }
            }
        }
    }
    
    private static func isNameFirstOrLastCharacter(_ character: Character) -> Bool {
        character.isLetter || character.isNumber
    }
    
    private static func isNameCharacter(_ character: Character) -> Bool {
        isNameFirstOrLastCharacter(character) || character == "-"

    }
}


