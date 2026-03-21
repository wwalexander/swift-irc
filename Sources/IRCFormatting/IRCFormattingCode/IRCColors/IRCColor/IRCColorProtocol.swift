import SwiftUI
import Parsing

protocol IRCColorProtocol: Sendable, Equatable {
    associatedtype Parser: ParserPrinter<Substring, Self>
    init?(color: Color)
    var color: Color? { get }
    static var parser: Parser { get }
}
