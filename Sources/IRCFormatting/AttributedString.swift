import Parsing
import Foundation
import SwiftUI

extension AttributedString {
    public init(irc: String) throws {
        self.init()
        
        var state = State()
        
        for component in try Components.parser.parse(irc).rawValue {
            switch component {
            case let .verbatim(string):
                var string = AttributedString(string)
                state.apply(to: &string)
                append(string)
            case let .code(code):
                state.update(with: code)
            }
        }
    }

    public var irc: String {
        let components = Components(rawValue: runs.flatMap { run in
            var components: [Component] = []
            
            if run.font == .default.bold() {
                components.append(.code(.bold))
            }
            
            if run.font == .default.italic() {
                components.append(.code(.italics))
            }
            
            if run.font == .default.monospaced() {
                components.append(.code(.monospace))
            }
            
            if run.underlineStyle == .single {
                components.append(.code(.underline))
            }
            
            if run.strikethroughStyle == .single {
                components.append(.code(.strikethrough))
            }
            
            if let ircColors = IRCColors<IRCColor>(
                foregroundColor: run.foregroundColor,
                backgroundColor: run.backgroundColor
            ) {
                components.append(.code(.color(ircColors)))
            } else if let ircColors = IRCColors<IRCHexColor>(
                foregroundColor: run.foregroundColor,
                backgroundColor: run.backgroundColor
            ) {
                components.append(.code(.hexColor(ircColors)))
            }
            
            let isFormatted = !components.isEmpty
            components.append(.verbatim(.init(self[run.range].characters)))
            
            if isFormatted {
                components.append(.code(.reset))
            }
            
            return components
        })
        
        return .init(try! Components.parser.print(components))
    }
}

fileprivate struct Components: RawRepresentable {
    var rawValue: [Component]
    
    static var parser: some ParserPrinter<Substring, Self> {
        Parse(.representing(Self.self)) {
            Many {
                Component.parser
            }
        }
    }
}

fileprivate enum Component {
    case verbatim(String)
    case code(IRCFormattingCode)
    
    @inlinable
    static var parser: some ParserPrinter<Substring, Self> {
        OneOf {
            Prefix(1..., while: \.isNotIRCFormattingCode).map(.string.map(.case(verbatim)))
            IRCFormattingCode.parser.map(.case(code))
        }
    }
}

fileprivate extension Character {
    var isNotIRCFormattingCode: Bool {
        self != "\u{02}" &&
        self != "\u{1D}" &&
        self != "\u{1F}" &&
        self != "\u{1E}" &&
        self != "\u{11}" &&
        self != "\u{03}" &&
        self != "\u{04}" &&
        self != "\u{16}" &&
        self != "\u{0F}"
    }
}

fileprivate struct State {
    var boldIsActive = false
    var italicIsActive = false
    var monospacedIsActive = false
    var underlineStyle: Text.LineStyle?
    var strikethroughStyle: Text.LineStyle?
    var foregroundColor: Color?
    var backgroundColor: Color?
    
    @inlinable
    mutating func update(with code: IRCFormattingCode) {
        switch code {
        case .bold:
            boldIsActive.toggle()
        case .italics:
            italicIsActive.toggle()
        case .monospace:
            monospacedIsActive.toggle()
        case .underline:
            underlineStyle.toggle()
        case .strikethrough:
            strikethroughStyle.toggle()
        case let .color(colors):
            updateColors(colors)
        case let .hexColor(colors):
            updateColors(colors)
        case .reverseColor:
            (foregroundColor, backgroundColor) = (backgroundColor, foregroundColor)
        case .reset:
            self = .init()
        }
    }
    
    @inlinable
    mutating func updateColors(_ colors: IRCColors<some IRCColorProtocol>?) {
        if let colors {
            foregroundColor = colors.foreground.color
            
            if let background = colors.background {
                backgroundColor = background.color
            }
        } else {
            foregroundColor = nil
            backgroundColor = nil
        }
    }
    
    @inlinable
    func apply(to string: inout AttributedString) {
        string.font = .default
            .bold(boldIsActive)
            .italic(italicIsActive)
            .monospaced(monospacedIsActive)
    
        string.underlineStyle = underlineStyle
        string.strikethroughStyle = strikethroughStyle
        string.foregroundColor = foregroundColor
        string.backgroundColor = backgroundColor
    }
}


fileprivate extension Text.LineStyle? {
    mutating func toggle() {
        self = switch self {
        case .some: .none
        case .none: .single
        }
    }
}
