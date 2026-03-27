import Parsing

protocol HostProtocol: ExpressibleByStringInterpolation, ParsePrintable {
    var rawValue: String { get }
    init(rawValue: String)
    static var minimumNames: Int { get }
}

extension HostProtocol {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
    }
}

extension HostProtocol {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(rawValue:)))) {
            Consumed {
                Many(minimumNames...) {
                    Prefix(1, while: \.isHostNameFirstOrLast)
                    Prefix(while: \.isHostName)
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
}

fileprivate extension Character {
    var isHostNameFirstOrLast: Bool {
        isLetter || isNumber
    }
    
    var isHostName: Bool {
        isHostNameFirstOrLast || self == "-"
    }
}



