import NonEmpty
import Parsing

public struct IRCMessageTags: Sendable, Equatable, RawRepresentable {
    public var rawValue: NonEmpty<[IRCMessageTag]>
    
    public init(rawValue: NonEmpty<[IRCMessageTag]>) {
        self.rawValue = rawValue
    }
}

extension IRCMessageTags: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init)) {
            Parse(.convert { input in
                NonEmpty<[IRCMessageTag]>(input)!
            } unapply: { output in
                output.map { $0 }
            }) {
                Many(1...) {
                    IRCMessageTag.parser
                } separator: {
                    ";"
                }
            }
        }
    }
}

extension IRCMessageTags: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: IRCMessageTag...) {
        self.init(rawValue: .init(elements)!)
    }
}

extension IRCMessageTags: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (IRCMessageTagKey, IRCMessageTagValue?)...) {
        self.init(rawValue: .init(elements.map(IRCMessageTag.init))!)
    }
}

extension IRCMessageTags: MutableCollection, RandomAccessCollection {
    public subscript(position: RawValue.Index) -> IRCMessageTag {
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
