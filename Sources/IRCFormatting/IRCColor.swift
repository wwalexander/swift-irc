import Parsing
import SwiftUI

struct IRCColor: Equatable, RawRepresentable {
    var rawValue: UInt8
    
    @inlinable
    init?(rawValue: UInt8) {
        guard (0...99).contains(rawValue) else {
            return nil
        }
        
        self.rawValue = rawValue
    }
    
    @inlinable
    static var parser: some ParserPrinter<Substring, Self> {
        Parse(.convert { input in
            UInt8(input)
        } unapply: { output in
            Int(output)
        }.representing(Self.self)) {
            Digits(1...2)
        }
    }
}

extension IRCColor: ExpressibleByIntegerLiteral {
    @inlinable
    init(integerLiteral value: UInt8) {
        self.init(rawValue: value)!
    }
}

extension IRCColor: CaseIterable {
    static let allCases = (00...99).compactMap(Self.init)
}

extension IRCColor: IRCColorProtocol {
    @inlinable
    init?(color: Color) {
        guard let ircColor = Self.allCases.first(where: { $0.color == color }) else {
            return nil
        }
        
        self = ircColor
    }
    
    @inlinable
    var color: Color? {
        switch self {
        case 00: .black
        case 01: .white
        case 02: .indigo
        case 03: .green
        case 04: .red
        case 05: .brown
        case 06: .purple
        case 07: .orange
        case 08: .yellow
        case 09: .mint
        case 10: .teal
        case 11: .cyan
        case 12: .blue
        case 13: .pink
        case 14: .gray
        case 15: .gray.opacity(0.5)
        case 16: (0x470000 as IRCHexColor).color
        case 17: (0x472100 as IRCHexColor).color
        case 18: (0x474700 as IRCHexColor).color
        case 19: (0x324700 as IRCHexColor).color
        case 20: (0x004700 as IRCHexColor).color
        case 21: (0x00472c as IRCHexColor).color
        case 22: (0x004747 as IRCHexColor).color
        case 23: (0x002747 as IRCHexColor).color
        case 24: (0x000047 as IRCHexColor).color
        case 25: (0x2e0047 as IRCHexColor).color
        case 26: (0x470047 as IRCHexColor).color
        case 27: (0x47002a as IRCHexColor).color
        case 28: (0x740000 as IRCHexColor).color
        case 29: (0x743a00 as IRCHexColor).color
        case 30: (0x747400 as IRCHexColor).color
        case 31: (0x517400 as IRCHexColor).color
        case 32: (0x007400 as IRCHexColor).color
        case 33: (0x007449 as IRCHexColor).color
        case 34: (0x007474 as IRCHexColor).color
        case 35: (0x004074 as IRCHexColor).color
        case 36: (0x000074 as IRCHexColor).color
        case 37: (0x4b0074 as IRCHexColor).color
        case 38: (0x740074 as IRCHexColor).color
        case 39: (0x740045 as IRCHexColor).color
        case 40: (0xb50000 as IRCHexColor).color
        case 41: (0xb56300 as IRCHexColor).color
        case 42: (0xb5b500 as IRCHexColor).color
        case 43: (0x7db500 as IRCHexColor).color
        case 44: (0x00b500 as IRCHexColor).color
        case 45: (0x00b571 as IRCHexColor).color
        case 46: (0x00b5b5 as IRCHexColor).color
        case 47: (0x0063b5 as IRCHexColor).color
        case 48: (0x0000b5 as IRCHexColor).color
        case 49: (0x7500b5 as IRCHexColor).color
        case 50: (0xb500b5 as IRCHexColor).color
        case 51: (0xb5006b as IRCHexColor).color
        case 52: (0xff0000 as IRCHexColor).color
        case 53: (0xff8c00 as IRCHexColor).color
        case 54: (0xffff00 as IRCHexColor).color
        case 55: (0xb2ff00 as IRCHexColor).color
        case 56: (0x00ff00 as IRCHexColor).color
        case 57: (0x00ffa0 as IRCHexColor).color
        case 58: (0x00ffff as IRCHexColor).color
        case 59: (0x008cff as IRCHexColor).color
        case 60: (0x0000ff as IRCHexColor).color
        case 61: (0xa500ff as IRCHexColor).color
        case 62: (0xff00ff as IRCHexColor).color
        case 63: (0xff0098 as IRCHexColor).color
        case 64: (0xff5959 as IRCHexColor).color
        case 65: (0xffb459 as IRCHexColor).color
        case 66: (0xffff71 as IRCHexColor).color
        case 67: (0xcfff60 as IRCHexColor).color
        case 68: (0x6fff6f as IRCHexColor).color
        case 69: (0x65ffc9 as IRCHexColor).color
        case 70: (0x6dffff as IRCHexColor).color
        case 71: (0x59b4ff as IRCHexColor).color
        case 72: (0x5959ff as IRCHexColor).color
        case 73: (0xc459ff as IRCHexColor).color
        case 74: (0xff66ff as IRCHexColor).color
        case 75: (0xff59bc as IRCHexColor).color
        case 76: (0xff9c9c as IRCHexColor).color
        case 77: (0xffd39c as IRCHexColor).color
        case 78: (0xffff9c as IRCHexColor).color
        case 79: (0xe2ff9c as IRCHexColor).color
        case 80: (0x9cff9c as IRCHexColor).color
        case 81: (0x9cffdb as IRCHexColor).color
        case 82: (0x9cffff as IRCHexColor).color
        case 83: (0x9cd3ff as IRCHexColor).color
        case 84: (0x9c9cff as IRCHexColor).color
        case 85: (0xdc9cff as IRCHexColor).color
        case 86: (0xff9cff as IRCHexColor).color
        case 87: (0xff94d3 as IRCHexColor).color
        case 88: (0x000000 as IRCHexColor).color
        case 89: (0x131313 as IRCHexColor).color
        case 90: (0x282828 as IRCHexColor).color
        case 91: (0x363636 as IRCHexColor).color
        case 92: (0x4d4d4d as IRCHexColor).color
        case 93: (0x656565 as IRCHexColor).color
        case 94: (0x818181 as IRCHexColor).color
        case 95: (0x9f9f9f as IRCHexColor).color
        case 96: (0xbcbcbc as IRCHexColor).color
        case 97: (0xe2e2e2 as IRCHexColor).color
        case 98: (0xffffff as IRCHexColor).color
        default: nil
        }
    }
}
