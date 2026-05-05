import Parsing

public struct IRCHost: Sendable, Equatable, Hashable {
    public let rawValue: String
}

extension IRCHost: IRCHostProtocol {
    static let minimumNames = 1
}

