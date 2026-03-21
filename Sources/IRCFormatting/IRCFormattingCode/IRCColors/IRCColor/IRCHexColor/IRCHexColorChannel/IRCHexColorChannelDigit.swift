import Parsing

enum IRCHexColorChannelDigit: UInt8 {
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case a
    case b
    case c
    case d
    case e
    case f
    
    @inlinable
    static var parser: some ParserPrinter<Substring, Self> {
        OneOf {
            "0".map(.case(zero))
            "1".map(.case(one))
            "2".map(.case(two))
            "3".map(.case(three))
            "4".map(.case(four))
            "5".map(.case(five))
            "6".map(.case(six))
            "7".map(.case(seven))
            "8".map(.case(eight))
            "9".map(.case(nine))
            "A".caseInsensitive.map(.case(a))
            "B".caseInsensitive.map(.case(b))
            "C".caseInsensitive.map(.case(c))
            "D".caseInsensitive.map(.case(d))
            "E".caseInsensitive.map(.case(e))
            "F".caseInsensitive.map(.case(f))
        }
    }
}

extension IRCHexColorChannelDigit: ExpressibleByIntegerLiteral {
    @inlinable
    init(integerLiteral value: UInt8) {
        self.init(rawValue: value)!
    }
}
