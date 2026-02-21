import Parsing

public struct Prefix: Sendable, Equatable {
    let unchecked: String
}

extension Prefix: ParsePrintable, RawRepresentable, ExpressibleByStringLiteral {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(unchecked:)))) {
            OneOf {
                Consumed {
                    ServerName.parser
                }
                Consumed {
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
}
