import Testing
@testable import IRCConnectivity

@Test func example() async throws {
    let connection = IRCConnection(host: "irc.libera.chat")
    try await connection.start()
    try await connection.register(nickname: "wwalexander", userName: "wwalexander", realName: "William Alexander")
    try await Task.sleep(for: .seconds(10))
}
