import Parsing
import Foundation

extension StringProtocol where SubSequence == Substring {
    @inlinable
    var caseInsensitive: some ParserPrinter<Substring, Void> {
        ParsePrint(.convert { _ in () } unapply: { self[...] }) {
            Prefix(self.count)
                .filter { $0.caseInsensitiveCompare(self) == .orderedSame }
        }
    }
}
