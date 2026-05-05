import Testing
@testable import IRCMessaging

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
    IRCMessage(
        source: .server("irc.example.com"),
        .client(.cap), .init("LS", "*", trailing: "multi-prefix extended-join sasl")
    ),
    IRCMessage(
        tags: ["id": "234AB"],
        source: .client("dan", user: "d", host: "localhost"),
        .client(.privMsg), .init("#chan", trailing: "Hey what's up!")
    ),
    IRCMessage(.client(.cap), .init("REQ", trailing: "sasl")),
    IRCMessage(
        source: .server("irc.example.com"),
        .client(.cap), .init("*", "LIST", trailing: "")
    ),
    IRCMessage(.client(.cap), .init("*", "LS", trailing: "multi-prefix sasl")),
    IRCMessage(.client(.cap), .init("REQ", trailing: "sasl message-tags foo")
    ),
    IRCMessage(
        source: .client("dan", user: "d", host: "localhost"),
        .client(.privMsg), .init("#chan", trailing: "Hey!")
    ),
    IRCMessage(
        source: .client("dan", user: "d", host: "localhost"),
        .client(.privMsg), .init("#chan", "Hey!")
    ),
    IRCMessage(
        source: .client("dan", user: "d", host: "localhost"),
        .client(.privMsg), .init("#chan", trailing: ":-)"),
    ),
    IRCMessage(
        source: .client("nick", user: "ident", host: "host.com"),
        .client(.privMsg), .init("me", trailing: "Hello"),
    ),
    IRCMessage(
        tags: [
            "aaa": "bbb",
            "ccc": nil,
            .init(vendor: .init(host: "example.com"), "ddd"): "eee"
        ],
        source: .client("nick", user: "ident", host: "host.com"),
        .client(.privMsg), .init("me", trailing: "Hello"),
    ),
    IRCMessage(
        tags: ["example-tag": "example-value"],
        .client(.privMsg), .init("#channel", trailing: "Message"),
    ),
    IRCMessage(
        tags: [.init(isClientOnly: true, "example-client-tag"): "example-value"],
        .client(.privMsg), .init("#channel", trailing: "Message"),
    ),
    IRCMessage(
        source: .client(
            "nick",
            user: "user",
            host: "example.com"
        ),
        .client(.privMsg), .init("#channel", trailing: "https://example.com/a-news-story")
    ),
    IRCMessage(
        tags: [.init(isClientOnly: true, "icon"): "https://example.com/favicon.png"],
        source: .client(
            "url_bot",
            user: "bot",
            host: "example.com"
        ),
        .client(.privMsg), .init("#channel", trailing: "Example.com: A News Story")
    ),
    IRCMessage(
        tags: [.init(isClientOnly: true, vendor: .init(host: "example.com"), "foo"): "bar"],
        source: .server("irc.example.com"),
        .client(.notice), .init("#channel", trailing: "A vendor-prefixed client-only tagged message")
    ),
    IRCMessage(
        tags: [.init(isClientOnly: true, "example"): #"raw+:=,escaped; \"#],
        source: .server("irc.example.com"),
        .client(.notice), .init("#channel", trailing: "Message")
    ),
    IRCMessage(
        tags: [.init(isClientOnly: true, "example-client-tag"): "example-value"],
        .client("TAGMSG"), .init("#channel")
    ),
    IRCMessage(
        tags: [.init(isClientOnly: true, "example-client-tag"): "example-value"],
        .client("TAGMSG"), .init("@#channel")
    ),
    IRCMessage(
        tags: [
            "label": "123",
            .init(isClientOnly: true, "example-client-tag"): "example-value",
        ],
        .client("TAGMSG"), .init("#channel")
    ),
    IRCMessage(
        tags: [
            "label": "123",
            "msgid": "abc",
            .init(isClientOnly: true, "example-client-tag"): "example-value",
        ],
        source: .client("nick", user: "user", host: "example.com"),
        .client("TAGMSG"), .init("#channel")
    ),
    IRCMessage(
        tags: [
            "msgid": "abc",
            .init(isClientOnly: true, "example-client-tag"): "example-value",
        ],
        source: .client("nick", user: "user", host: "example.com"),
        .client("TAGMSG"), .init("#channel")
    ),
    IRCMessage(
        tags: [
            .init(isClientOnly: true, "tag1"): nil,
            .init(isClientOnly: true, "tag2"): nil,
            .init(isClientOnly: true, "tag5000"): nil,
        ],
        .client("TAGMSG"), .init("#channel")
    ),
    IRCMessage(
        source: .server("server.example.com"),
        IRCCommand.numeric(.inputTooLong),
        .init("nick", trailing: "Input line was too long")
    ),
    IRCMessage(
        tags: ["unknown-tag"],
        .client("TAGMSG"), .init("#channel")
    ),
    IRCMessage(
        source: .client("nick", user: "user", host: "example.com"),
        .client("TAGMSG"), .init("#channel")
    ),
])) func testMessage(input: Substring, output: IRCMessage) throws {
    #expect(try IRCMessage(parsing: input) == output)
    #expect(try output.printed == input)
}

@Test(arguments: zip([
    "id=123AB;rose",
    "url=;netsplit=tur,ty",
], [
    ["id": "123AB", "rose": nil] as IRCMessageTags,
    ["url": "", "netsplit": "tur,ty"] as IRCMessageTags,
])) func testTags(input: Substring, output: IRCMessageTags) throws {
    #expect(try IRCMessageTags(parsing: input) == output)
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
    "foo" as IRCMessageTagKey,
    IRCMessageTagKey(vendor: .init(host: "example"), "bar"),
    IRCMessageTagKey(vendor: .init(host: "znc.in"), "server-time"),
    IRCMessageTagKey(vendor: .init(host: "xn--e1afmkfd.org"), "foo"),
    IRCMessageTagKey(vendor: .init(host: "draft"), "foo"),
    IRCMessageTagKey(vendor: .init(host: "draft"), "foo-0.2"),
])) func testKey(input: Substring, output: IRCMessageTagKey) throws {
    #expect(try IRCMessageTagKey(parsing: input) == output)
    #expect(try output.printed == input)
}

@Test(arguments: zip([
    "draft"
], [
    IRCMessageTagVendor(host: "draft"),
])) func testVendor(input: Substring, output: IRCMessageTagVendor) throws {
    #expect(try IRCMessageTagVendor(parsing: input) == output)
    #expect(try output.printed == input)
}

@Test(arguments: zip([
    #"raw+:=,escaped\:\s\\"#
], [
    #"raw+:=,escaped; \"# as IRCMessageTagValue
])) func testValue(input: Substring, output: IRCMessageTagValue) throws {
    #expect(try IRCMessageTagValue(parsing: input) == output)
    #expect(try output.printed == input)
}
