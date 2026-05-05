import Parsing

public enum IRCMessageSource: Sendable, Equatable {
    case server(IRCServerName)
    case client(
        IRCNickname,
        user: IRCUser? = nil,
        host: IRCHost? = nil
    )
}

extension IRCMessageSource: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        OneOf {
            Parse(.case(server)) {
                IRCServerName.parser
            }
            Parse(.case(client)) {
                IRCNickname.parser
                Optionally {
                    "!"
                    IRCUser.parser
                }
                Optionally {
                    "@"
                    IRCHost.parser
                }
            }
            
        }
    }
}
