import Parsing

public struct Nick: Sendable, Equatable {
    let unchecked: String
}

import Foundation
extension Nick: ParsePrintable, RawRepresentable, ExpressibleByStringLiteral {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(unchecked:)))) {
            Consumed {
                Parsing.Prefix(1) {
                    $0.isLetter
                }
                Parsing.Prefix {
                    $0.isLetter || $0.isNumber || $0.isSpecial
                }
            }
        }
    }
}

extension Character {
    fileprivate var isSpecial: Bool {
        self == "-" || self == "[" || self == "]" || self == #"\"# || self == "`" || self == "^" || self == "{" || self == "}"
    }
}
