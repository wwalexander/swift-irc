import Parsing

public struct ServerName: Sendable, Equatable {
    public var host: Host
    
    public init(host: Host) {
        self.host = host
    }
}

extension ServerName: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            Host.parser
        }
    }
}
