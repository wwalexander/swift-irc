import Parsing

public struct Vendor: Sendable, Equatable, ParsePrintable {
    public var host: Host
    
    public init(host: Host) {
        self.host = host
    }
    
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            Host.parser
        }
    }
}
