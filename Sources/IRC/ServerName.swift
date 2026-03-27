public struct ServerName: Sendable, Equatable, Hashable {
    let rawValue: String
}

extension ServerName: HostProtocol {
    /**
     Technically, [RFC 952](https://datatracker.ietf.org/doc/html/rfc952#page-5) allows a single-name hostname but requiring at least 2 names (such that there is a dot in the hostname) avoids ambiguity with nicknames.
     */
    static let minimumNames = 2
}

