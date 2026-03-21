import Parsing

public struct Host: Sendable, Equatable {
    let value: String
}

extension Host: HostProtocol {
    static let minimumNames = 1
}
