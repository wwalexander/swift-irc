import Parsing


public struct CapabilityChanges: Sendable, Equatable, RawRepresentable {
    public var rawValue: [CapabilityChange]
    
    public init(rawValue: [CapabilityChange]) {
        self.rawValue = rawValue
    }
    
    public func apply(to set: inout some SetAlgebra<Capability>) {
        forEach { change in
            change.apply(to: &set)
        }
    }
}

extension CapabilityChanges: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(rawValue:))) {
            Many {
                CapabilityChange.parser
            } separator: {
                " "
            }
        }
    }
}

extension CapabilityChanges: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CapabilityChange...) {
        self.init(rawValue: elements)
    }
}

extension CapabilityChanges: MutableCollection, RandomAccessCollection {
    public subscript(position: RawValue.Index) -> CapabilityChange {
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
