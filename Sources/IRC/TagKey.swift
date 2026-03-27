import Parsing

// TODO: Rename to TagKey
public struct TagKey: Sendable, Equatable {
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
}

extension TagKey: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(isClientOnly:vendor:_:))) {
            "+".map { true }.replaceError(with: false)
            Optionally {
                Vendor.parser
                "/"
            }
            KeyName.parser
        }
    }
}

extension TagKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(isClientOnly: false, .init(stringLiteral: value))
    }
}
