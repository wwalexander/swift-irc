import Parsing

public struct Host: Sendable, Equatable, Hashable {
    public let rawValue: String
}

extension Host: HostProtocol {
    static let minimumNames = 1
}

