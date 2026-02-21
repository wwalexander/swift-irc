import Parsing

public struct Vendor: Sendable, Equatable {
    public var host: Host
    
    public init(host: Host) {
        self.host = host
    }
}

extension Vendor: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(host:))) {
            Host.parser
        }
    }
}
