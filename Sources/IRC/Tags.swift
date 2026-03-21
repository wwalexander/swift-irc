import NonEmpty
import Parsing

public struct Tags: Sendable, Equatable, RawRepresentable {
    public var rawValue: NonEmpty<[Tag]>
    
    public init(rawValue: NonEmpty<[Tag]>) {
        self.rawValue = rawValue
    }
}

extension Tags: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            Parse(.convert { input in
                NonEmpty<[Tag]>(input)!
            } unapply: { output in
                output.map { $0 }
            }) {
                Many(1...) {
                    Tag.parser
                } separator: {
                    ";"
                }
            }
        }
    }
}

extension Tags: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Tag...) {
        self.init(rawValue: .init(elements)!)
    }
}

extension Tags: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value?)...) {
        self.init(rawValue: .init(elements.map(Tag.init))!)
    }
}

extension Tags: MutableCollection, RandomAccessCollection {
    public subscript(position: RawValue.Index) -> Tag {
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
