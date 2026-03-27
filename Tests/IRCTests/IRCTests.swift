import Testing
@testable import IRC

@Test func example() async throws {
    let connection = Connection(host: "irc.libera.chat")
    try await connection.start()
    try await connection.register(nickname: "wwalexander", userName: "wwalexander", realName: "William Alexander")
    try await Task.sleep(for: .seconds(10))
}

@Suite struct ParsingTests {
    @Test(arguments: zip([
        ":irc.example.com CAP LS * :multi-prefix extended-join sasl",
        "@id=234AB :dan!d@localhost PRIVMSG #chan :Hey what's up!",
        "CAP REQ :sasl",
        ":irc.example.com CAP * LIST :",
        "CAP * LS :multi-prefix sasl",
        "CAP REQ :sasl message-tags foo",
        ":dan!d@localhost PRIVMSG #chan :Hey!",
        ":dan!d@localhost PRIVMSG #chan Hey!",
        ":dan!d@localhost PRIVMSG #chan ::-)",
        ":nick!ident@host.com PRIVMSG me :Hello",
        "@aaa=bbb;ccc;example.com/ddd=eee :nick!ident@host.com PRIVMSG me :Hello",
        "@example-tag=example-value PRIVMSG #channel :Message",
        "@+example-client-tag=example-value PRIVMSG #channel :Message",
        ":nick!user@example.com PRIVMSG #channel :https://example.com/a-news-story",
        "@+icon=https://example.com/favicon.png :url_bot!bot@example.com PRIVMSG #channel :Example.com: A News Story",
        "@+example.com/foo=bar :irc.example.com NOTICE #channel :A vendor-prefixed client-only tagged message",
        #"@+example=raw+:=,escaped\:\s\\ :irc.example.com NOTICE #channel :Message"#,
        "@+example-client-tag=example-value TAGMSG #channel",
        "@+example-client-tag=example-value TAGMSG @#channel",
        "@label=123;+example-client-tag=example-value TAGMSG #channel",
        "@label=123;msgid=abc;+example-client-tag=example-value :nick!user@example.com TAGMSG #channel",
        "@msgid=abc;+example-client-tag=example-value :nick!user@example.com TAGMSG #channel",
        "@+tag1;+tag2;+tag5000 TAGMSG #channel",
        ":server.example.com 417 nick :Input line was too long",
        "@unknown-tag TAGMSG #channel",
        ":nick!user@example.com TAGMSG #channel",
    ], [
        Message(
            source: .server("irc.example.com"),
            .client(.cap), .init("LS", "*", trailing: "multi-prefix extended-join sasl")
        ),
        Message(
            tags: ["id": "234AB"],
            source: .client("dan", user: "d", host: "localhost"),
            .client(.privMsg), .init("#chan", trailing: "Hey what's up!")
        ),
        Message(.client(.cap), .init("REQ", trailing: "sasl")),
        Message(
            source: .server("irc.example.com"),
            .client(.cap), .init("*", "LIST", trailing: "")
        ),
        Message(.client(.cap), .init("*", "LS", trailing: "multi-prefix sasl")),
        Message(.client(.cap), .init("REQ", trailing: "sasl message-tags foo")
        ),
        Message(
            source: .client("dan", user: "d", host: "localhost"),
            .client(.privMsg), .init("#chan", trailing: "Hey!")
        ),
        Message(
            source: .client("dan", user: "d", host: "localhost"),
            .client(.privMsg), .init("#chan", "Hey!")
        ),
        Message(
            source: .client("dan", user: "d", host: "localhost"),
            .client(.privMsg), .init("#chan", trailing: ":-)"),
        ),
        Message(
            source: .client("nick", user: "ident", host: "host.com"),
            .client(.privMsg), .init("me", trailing: "Hello"),
        ),
        Message(
            tags: [
                "aaa": "bbb",
                "ccc": nil,
                .init(vendor: .init(host: "example.com"), "ddd"): "eee"
            ],
            source: .client("nick", user: "ident", host: "host.com"),
            .client(.privMsg), .init("me", trailing: "Hello"),
        ),
        Message(
            tags: ["example-tag": "example-value"],
            .client(.privMsg), .init("#channel", trailing: "Message"),
        ),
        Message(
            tags: [.init(isClientOnly: true, "example-client-tag"): "example-value"],
            .client(.privMsg), .init("#channel", trailing: "Message"),
        ),
        Message(
            source: .client(
                "nick",
                user: "user",
                host: "example.com"
            ),
            .client(.privMsg), .init("#channel", trailing: "https://example.com/a-news-story")
        ),
        Message(
            tags: [.init(isClientOnly: true, "icon"): "https://example.com/favicon.png"],
            source: .client(
                "url_bot",
                user: "bot",
                host: "example.com"
            ),
            .client(.privMsg), .init("#channel", trailing: "Example.com: A News Story")
        ),
        Message(
            tags: [.init(isClientOnly: true, vendor: .init(host: "example.com"), "foo"): "bar"],
            source: .server("irc.example.com"),
            .client(.notice), .init("#channel", trailing: "A vendor-prefixed client-only tagged message")
        ),
        Message(
            tags: [.init(isClientOnly: true, "example"): #"raw+:=,escaped; \"#],
            source: .server("irc.example.com"),
            .client(.notice), .init("#channel", trailing: "Message")
        ),
        Message(
            tags: [.init(isClientOnly: true, "example-client-tag"): "example-value"],
            .client("TAGMSG"), .init("#channel")
        ),
        Message(
            tags: [.init(isClientOnly: true, "example-client-tag"): "example-value"],
            .client("TAGMSG"), .init("@#channel")
        ),
        Message(
            tags: [
                "label": "123",
                .init(isClientOnly: true, "example-client-tag"): "example-value",
            ],
            .client("TAGMSG"), .init("#channel")
        ),
        Message(
            tags: [
                "label": "123",
                "msgid": "abc",
                .init(isClientOnly: true, "example-client-tag"): "example-value",
            ],
            source: .client("nick", user: "user", host: "example.com"),
            .client("TAGMSG"), .init("#channel")
        ),
        Message(
            tags: [
                "msgid": "abc",
                .init(isClientOnly: true, "example-client-tag"): "example-value",
            ],
            source: .client("nick", user: "user", host: "example.com"),
            .client("TAGMSG"), .init("#channel")
        ),
        Message(
            tags: [
                .init(isClientOnly: true, "tag1"): nil,
                .init(isClientOnly: true, "tag2"): nil,
                .init(isClientOnly: true, "tag5000"): nil,
            ],
            .client("TAGMSG"), .init("#channel")
        ),
        Message(
            source: .server("server.example.com"),
            Command.numeric(.inputTooLong),
            .init("nick", trailing: "Input line was too long")
        ),
        Message(
            tags: ["unknown-tag"],
            .client("TAGMSG"), .init("#channel")
        ),
        Message(
            source: .client("nick", user: "user", host: "example.com"),
            .client("TAGMSG"), .init("#channel")
        ),
    ])) func testMessage(input: Substring, output: Message) throws {
        #expect(try Message(parsing: input) == output)
        #expect(try output.printed == input)
    }
    
    @Test(arguments: zip([
        "id=123AB;rose",
        "url=;netsplit=tur,ty",
    ], [
        ["id": "123AB", "rose": nil] as Tags,
        ["url": "", "netsplit": "tur,ty"] as Tags,
    ])) func testTags(input: Substring, output: Tags) throws {
        #expect(try Tags(parsing: input) == output)
        #expect(try output.printed == input)
    }
    
    @Test(arguments: zip([
        "foo",
        "example/bar",
        "znc.in/server-time",
        "xn--e1afmkfd.org/foo",
        "draft/foo",
        "draft/foo-0.2",
    ], [
        "foo" as TagKey,
        TagKey(vendor: .init(host: "example"), "bar"),
        TagKey(vendor: .init(host: "znc.in"), "server-time"),
        TagKey(vendor: .init(host: "xn--e1afmkfd.org"), "foo"),
        TagKey(vendor: .init(host: "draft"), "foo"),
        TagKey(vendor: .init(host: "draft"), "foo-0.2"),
    ])) func testKey(input: Substring, output: TagKey) throws {
        #expect(try TagKey(parsing: input) == output)
        #expect(try output.printed == input)
    }
    
    @Test(arguments: zip([
        "draft"
    ], [
        Vendor(host: "draft"),
    ])) func testVendor(input: Substring, output: Vendor) throws {
        #expect(try Vendor(parsing: input) == output)
        #expect(try output.printed == input)
    }
    
    @Test(arguments: zip([
        #"raw+:=,escaped\:\s\\"#
    ], [
        #"raw+:=,escaped; \"# as TagValue
    ])) func testValue(input: Substring, output: TagValue) throws {
        #expect(try TagValue(parsing: input) == output)
        #expect(try output.printed == input)
    }
}
