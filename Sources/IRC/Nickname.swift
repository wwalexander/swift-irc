import Parsing

public struct Nickname: Sendable, Equatable {
    let value: String
}

extension Nickname: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(value:)))) {
            Consumed {
                Prefix(1, while: \.isNickFirst)
                Prefix(while: \.isNick)
            }
        }
    }
}

extension Nickname: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value[...])
    }
}

fileprivate extension Character {
    var isNickFirst: Bool {
        isNick &&
        self != "$" &&
        self != ":" &&
        !isChannelType &&
        !isChannelMembershipPrefix
    }
    
    var isChannelType: Bool {
        ChannelType.allCases.contains { self == $0.rawValue }
    }
    
    var isChannelMembershipPrefix: Bool {
        ChannelMembership.allCases.contains { self == $0.rawValue }
    }
    
    var isNick: Bool {
        self != " " &&
        self != "," &&
        self != "*" &&
        self != "?" &&
        self != "!" &&
        self != "@" &&
        self != "\0" &&
        self != "\r" &&
        self != "\n" &&
        self != " "
    }
}
