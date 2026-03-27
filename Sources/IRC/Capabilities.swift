import Parsing

public struct Capabilities: Sendable, Equatable, RawRepresentable {
    public var rawValue: [Capability]
    
    public init(rawValue: [Capability]) {
        self.rawValue = rawValue
    }
}

extension Capabilities: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(rawValue:))) {
            Many {
                Capability.parser
            } separator: {
                " "
            }
        }
    }
}

extension Capabilities: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Capability...) {
        self.init(rawValue: elements)
    }
}

extension Capabilities: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (CapabilityKey, CapabilityValue?)...) {
        self.init(rawValue: elements.map(Capability.init))
    }
}

extension Capabilities: MutableCollection, RandomAccessCollection {
    public subscript(position: RawValue.Index) -> Capability {
        _read {
            yield rawValue[position]
        }
        set(newValue) {
            rawValue[position] = newValue
        }
    }
    
    public var startIndex: RawValue.Index {
        rawValue.startIndex
    }
    
    public var endIndex: RawValue.Index {
        rawValue.endIndex
    }
    
    public func index(after i: RawValue.Index) -> RawValue.Index {
        rawValue.index(after: i)
    }
}

