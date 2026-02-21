import Parsing

//  <prefix>        ::= <servername> | <nick> [ '!' <user> ] [ '@' <host> ]


public enum Prefix: Sendable, Equatable {
    case user(Nick, user: User? = nil, host: Host? = nil)
    case server(ServerName)
}

extension Prefix: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        OneOf {
            Parse(.case(user)) {
                Nick.parser
                Optionally {
                    "!"
                    User.parser
                }
                Optionally {
                    "@"
                    Host.parser
                }
            }
            Parse(.case(server)) {
                ServerName.parser
            }
        }
    }
}
