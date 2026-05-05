import Parsing

struct IRCHexColorChannel {
    var digits: [2 of IRCHexColorChannelDigit]
}

extension IRCHexColorChannel: RawRepresentable {
    @inlinable
    init(rawValue: UInt8) {
        self.init(digits: [0x0, 0x0])
        digits[0] = .init(rawValue: (rawValue >> 4) & 0xf)!
        digits[1] = .init(rawValue: rawValue & 0xf)!
    }
    
    @inlinable
    var rawValue: UInt8 {
        digits[1].rawValue | (digits[0].rawValue << 4)
    }
}

extension IRCHexColorChannel: ExpressibleByIntegerLiteral {
    @inlinable
    init(integerLiteral value: UInt8) {
        self.init(rawValue: value)
    }
}

extension IRCHexColorChannel {
    @inlinable
    init(value: some BinaryFloatingPoint) {
        self.init(rawValue: .init(value * 0xff))
    }
    
    @inlinable
    var value: Double {
        Double(rawValue) / 0xff
    }
}


extension IRCHexColorChannel {
    @inlinable
    static var parser: some ParserPrinter<Substring, Self> {
        Parse(.inline().map(.memberwise(Self.init))) {
            Many(2) {
                IRCHexColorChannelDigit.parser
            }
        }
    }
}
