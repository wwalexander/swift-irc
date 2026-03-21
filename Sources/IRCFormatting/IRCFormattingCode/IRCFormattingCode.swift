import Parsing

enum IRCFormattingCode: Equatable {
    case bold
    case italics
    case underline
    case strikethrough
    case monospace
    case color(IRCColors<IRCColor>?)
    case hexColor(IRCColors<IRCHexColor>?)
    case reverseColor
    case reset
    
    @inlinable
    static var parser: some ParserPrinter<Substring, Self> {
        OneOf {
            "\u{02}".map(.case(bold))
            "\u{1D}".map(.case(italics))
            "\u{1F}".map(.case(underline))
            "\u{1E}".map(.case(strikethrough))
            "\u{11}".map(.case(monospace))
            Parse(.case(color)) {
                "\u{03}"
                Optionally {
                    IRCColors<IRCColor>.parser
                }
            }
            Parse(.case(hexColor)) {
                "\u{04}"
                Optionally {
                    IRCColors<IRCHexColor>.parser
                }
            }
            "\u{16}".map(.case(reverseColor))
            "\u{0F}".map(.case(reset))
        }
    }
}

