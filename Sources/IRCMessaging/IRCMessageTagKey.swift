import Parsing

public struct IRCMessageTagKey: Sendable, Equatable {
    public var isClientOnly: Bool
    public var vendor: IRCMessageTagVendor?
    public var name: IRCMessageTagKeyName
    
    public init(
        isClientOnly: Bool = false,
        vendor: IRCMessageTagVendor? = nil,
        _ name: IRCMessageTagKeyName
    ) {
        self.isClientOnly = isClientOnly
        self.vendor = vendor
        self.name = name
    }
}

extension IRCMessageTagKey: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(isClientOnly:vendor:_:))) {
            "+".map { true }.replaceError(with: false)
            Optionally {
                IRCMessageTagVendor.parser
                "/"
            }
            IRCMessageTagKeyName.parser
        }
    }
}

extension IRCMessageTagKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(isClientOnly: false, .init(stringLiteral: value))
    }
}
