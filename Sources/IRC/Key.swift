import Parsing

public struct Key: Sendable, Equatable {
    public var clientOnly: Bool
    public var vendor: Vendor?
    public var name: KeyName
    
    public init(
        clientOnly: Bool = false,
        vendor: Vendor? = nil,
        name: KeyName 
    ) {
        self.clientOnly = clientOnly
        self.vendor = vendor
        self.name = name
    }
}

extension Key: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            "+".map { true }.replaceError(with: false)
            Optionally {
                Vendor.parser
                "/"
            }
            KeyName.parser
        }
    }
}
