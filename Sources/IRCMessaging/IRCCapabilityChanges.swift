import Parsing

public struct IRCCapabilityChanges: Sendable, Equatable, RawRepresentable {
    public var rawValue: [IRCCapabilityChange]
    
    public init(rawValue: [IRCCapabilityChange]) {
        self.rawValue = rawValue
    }
    
    public func apply(to set: inout some SetAlgebra<IRCCapability>) {
        forEach { change in
            change.apply(to: &set)
        }
    }
}

extension IRCCapabilityChanges: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(rawValue:))) {
            Many {
                IRCCapabilityChange.parser
            } separator: {
                " "
            }
        }
    }
}

extension IRCCapabilityChanges: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: IRCCapabilityChange...) {
        self.init(rawValue: elements)
    }
}

extension IRCCapabilityChanges: MutableCollection, RandomAccessCollection {
    public subscript(position: RawValue.Index) -> IRCCapabilityChange {
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
