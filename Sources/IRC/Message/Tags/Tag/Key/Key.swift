import Parsing

public struct Key: Sendable, Equatable, ParsePrintable {
    public var isClientOnly: Bool
    public var vendor: Vendor?
    public var name: KeyName
    
    public init(
        isClientOnly: Bool = false,
        vendor: Vendor? = nil,
        _ name: KeyName
    ) {
        self.isClientOnly = isClientOnly
        self.vendor = vendor
        self.name = name
    }
    
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

extension Key: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(isClientOnly: false, .init(stringLiteral: value))
    }
}
