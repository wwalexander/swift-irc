import Parsing

protocol HostProtocol: ExpressibleByStringInterpolation, ParsePrintable {
    var value: String { get }
    init(value: String)
    static var minimumNames: Int { get }
}

extension HostProtocol {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value[...])
    }
}

extension HostProtocol {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(value:)))) {
            Consumed {
                Many(minimumNames...) {
                    Prefix(1, while: \.isHostNameFirstOrLast)
                    Prefix(while: \.isHostName)
                } separator: {
                    "."
                }
            }
        }
    }
}

fileprivate extension Character {
    var isHostNameFirstOrLast: Bool {
        isLetter || isNumber
    }
    
    var isHostName: Bool {
        isHostNameFirstOrLast || self == "-"
    }
}

public struct Host: Sendable, Equatable, HostProtocol {
    let value: String
    static let minimumNames = 1
}


public struct ServerName: Sendable, Equatable, HostProtocol {
    let value: String
    static let minimumNames = 2
}
