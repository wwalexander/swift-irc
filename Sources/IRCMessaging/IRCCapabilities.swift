import Parsing

public struct IRCCapabilities: Sendable, Equatable, RawRepresentable {
    public var rawValue: [IRCCapability]
    
    @inlinable
    public init(rawValue: [IRCCapability]) {
        self.rawValue = rawValue
    }
}

extension IRCCapabilities: ParsePrintable {
    @inlinable
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(rawValue:))) {
            Many {
                IRCCapability.parser
            } separator: {
                " "
            }
        }
    }
}

extension IRCCapabilities: ExpressibleByArrayLiteral {
    @inlinable
    public init(arrayLiteral elements: IRCCapability...) {
        self.init(rawValue: elements)
    }
}

extension IRCCapabilities: ExpressibleByDictionaryLiteral {
    @inlinable
    public init(dictionaryLiteral elements: (IRCCapabilityKey, IRCCapabilityValue?)...) {
        self.init(rawValue: elements.map(IRCCapability.init))
    }
}

extension IRCCapabilities: MutableCollection, RandomAccessCollection {
    @inlinable
    public subscript(position: RawValue.Index) -> IRCCapability {
        _read {
            yield rawValue[position]
        }
        set(newValue) {
            rawValue[position] = newValue
        }
    }
    
    @inlinable
    public var startIndex: RawValue.Index {
        rawValue.startIndex
    }
    
    @inlinable
    public var endIndex: RawValue.Index {
        rawValue.endIndex
    }
    
    @inlinable
    public func index(after i: RawValue.Index) -> RawValue.Index {
        rawValue.index(after: i)
    }
}

