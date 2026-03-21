import Parsing

@usableFromInline
struct ArrayToInlineArray<let count : Int, Element>: Conversion {
    public init(_ type: [count of Element].Type = [count of Element].self) {}
    
    @inlinable
    public func apply(_ input: [Element]) throws -> [count of Element] {
        .init { index in
            input[index]
        }
    }
    
    @inlinable
    public func unapply(_ output: [count of Element]) throws -> [Element] {
        output.indices.map { index in
            output[index]
        }
    }
}

extension Conversion {
    @inlinable
    static func inline<let count : Int, Element>(
        _ type: [count of Element].Type = [count of Element].self
    ) -> Self where Self == ArrayToInlineArray<count, Element> {
        .init(type)
    }
}
