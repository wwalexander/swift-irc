import Parsing

public enum Source: Sendable, Equatable, ParsePrintable {
    case server(ServerName)
    
    case client(
        Nickname,
        user: User? = nil,
        host: Host? = nil
    )
    
    public static var parser: some ParserPrinter<Substring, Self> {
        OneOf {
            Parse(.case(server)) {
                ServerName.parser
            }
            Parse(.case(client)) {
                Nickname.parser
                Optionally {
                    "!"
                    User.parser
                }
                Optionally {
                    "@"
                    Host.parser
                }
            }
            
        }
    }
}
