import SwiftUI
import Parsing

struct IRCColors<IRCColor: IRCColorProtocol>: Equatable {
    var foreground: IRCColor
    var background: IRCColor?
    
    @inlinable
    static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(foreground:background:))) {
            IRCColor.parser
            Optionally {
                ","
                IRCColor.parser
            }
        }
    }
}

extension IRCColors {
    init?(foregroundColor: Color?, backgroundColor: Color? = nil) {
        guard let foreground = foregroundColor.flatMap(IRCColor.init) else {
            return nil
        }
        
        self.init(
            foreground: foreground,
            background: backgroundColor.flatMap(IRCColor.init)
        )
    }
}
