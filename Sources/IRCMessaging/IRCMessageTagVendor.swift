import Parsing

public struct IRCMessageTagVendor: Sendable, Equatable, Hashable {
    public var host: IRCHost
    
    public init(host: IRCHost) {
        self.host = host
    }
}

extension IRCMessageTagVendor: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            IRCHost.parser
        }
    }
}
