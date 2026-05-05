import Parsing
import SwiftUI

struct IRCHexColor: Equatable {
    var channels: [3 of IRCHexColorChannel]
    
    @inlinable
    static var parser: some ParserPrinter<Substring, Self> {
        Parse(.inline().map(.memberwise(Self.init))) {
            Many(3) {
                IRCHexColorChannel.parser
            }
        }
    }
}

extension IRCHexColor: RawRepresentable {
    @inlinable
    init?(rawValue: UInt32) {
        guard (0x000000...0xffffff).contains(rawValue) else {
            return nil
        }
 
        self.init(channels: [0x00, 0x00, 0x00])
        channels[0] = .init(rawValue: .init((rawValue >> 16) & 0xff))
        channels[1] = .init(rawValue: .init((rawValue >> 8) & 0xff))
        channels[2] = .init(rawValue: .init(rawValue & 0xff))
    }
    
    @inlinable
    var rawValue: UInt32 {
        .init(channels[0].rawValue) << 16 |
        .init(channels[1].rawValue) << 8 |
        .init(channels[2].rawValue)
    }
}

extension IRCHexColor: ExpressibleByIntegerLiteral {
    @inlinable
    init(integerLiteral value: UInt32) {
        self.init(rawValue: value)!
    }
}

extension IRCHexColor: IRCColorProtocol {
    @inlinable
    init?(color: Color) {
        self = 0x000000
        let resolved = color.resolve(in: .init())

        for (offset, keyPath) in [\Color.Resolved.red, \.green, \.blue].enumerated() {
            channels[offset] = .init(value: resolved[keyPath: keyPath])
        }
    }
    
    @inlinable
    var color: Color? {
        .init(red: channels[0].value, green: channels[1].value, blue: channels[2].value)
    }
}
