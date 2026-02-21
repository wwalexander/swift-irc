import Parsing

public struct Tags: RawRepresentable, Sendable, Equatable {
    public var rawValue: [Tag]
    
    public init(rawValue: [Tag]) {
        self.rawValue = rawValue
    }
}

extension Tags: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            Many(1...) {
                Tag.parser
            } separator: {
                ";"
            }
        }
    }
}

extension Tags: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Tag...) {
        self.init(rawValue: elements)
    }
}

extension Tags: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, EscapedValue)...) {
        self.init(rawValue: elements.map(Tag.init))
    }
}

extension Tags: RandomAccessCollection, RangeReplaceableCollection {
    public init() {
        self.init(rawValue: [])
    }
    
    public var startIndex: RawValue.Index {
        rawValue.startIndex
    }
    
    public var endIndex: RawValue.Index {
        rawValue.endIndex
    }
    
    public subscript(position: RawValue.Index) -> RawValue.Element {
        rawValue[position]
    }
    
    public subscript(bounds: RawValue.Indices) -> RawValue.SubSequence {
        rawValue[bounds]
    }
    
    public mutating func replaceSubrange(
        _ subrange: Range<Int>,
        with newElements: some Collection<RawValue.Element>
    ) {
        rawValue.replaceSubrange(subrange, with: newElements)
    }
}
