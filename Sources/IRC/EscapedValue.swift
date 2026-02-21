import Parsing

public struct EscapedValue: Sendable, Equatable {
    let unchecked: String
}

extension EscapedValue: ParsePrintable, RawRepresentable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.convert {
            var output: Substring = $0
            
            for (other, replacement) in mapping {
                output.replace(other, with: replacement)
            }
            
            return output
        } unapply: {
            var input: Substring = $0
            
            for (replacement, other) in mapping {
                input.replace(other, with: replacement)
            }
            
            return input
        }.map(.string).map(.memberwise(Self.init(unchecked:)))) {
            Parsing.Prefix {
                $0 as Character != "\0" && $0 != "\r" && $0 != "\n" && $0 != ";" && $0 != " "
            }
        }
    }
    
    static let mapping = [
        #"\:"#: ";",
        #"\s"#: " ",
        #"\\"#: #"\"#,
        #"\r"#: "\r",
        #"\n"#: "\n",
    ]
}

extension EscapedValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        var rawValue = value
        
        for (replacement, other) in Self.mapping {
            rawValue.replace(other, with: replacement)
        }
        
        self.init(rawValue: value)!
    }
}
