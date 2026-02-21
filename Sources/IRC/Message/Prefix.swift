import Parsing

public enum Prefix: Sendable, Equatable {
    case user(Nick, user: User? = nil, host: Host? = nil)
    case server(ServerName)
}

extension Prefix: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
//        Parse(.string.map(.memberwise(Self.init(unchecked:)))) {
//            OneOf {
//                Consumed {
//                    ServerName.parser
//                }
//                Consumed {
//                    Nick.parser
//                    Optionally {
//                        "!"
//                        User.parser
//                    }
//                    Optionally {
//                        "@"
//                        Host.parser
//                    }
//                }
//               
//            }
//        }
        
        OneOf {
            Parse(.case(server)) {
                ServerName.parser
            }
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
        }
       
    }
}
