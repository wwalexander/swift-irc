import Testing
@testable import IRC

@Suite struct ParsingTests {
    @Test(arguments: zip([
        "example.com"
    ], [
        "example.com"
    ])) func testHost(input: String, output: Host) throws {
        #expect(try Host.parser.parse(input) == output)
        #expect(try Host.parser.print(output) == input)
    }
    
    @Test(arguments: zip([
        "example.com"
    ], [
        Vendor(host: "example.com")
    ])) func testVendor(input: String, output: Vendor) throws {
        #expect(try Vendor.parser.parse(input) == output)
        #expect(try Vendor.parser.print(output) == input)
    }
    
    @Test(arguments: zip([
        "+example.com/foo"
    ], [
        Key(clientOnly: true, vendor: .init(host: "example.com"), name: "foo")
    ])) func testKey(input: String, output: Key) throws {
        #expect(try Key.parser.parse(input) == output)
        #expect(try Key.parser.print(output) == input)
    }
    
    @Test(arguments: zip([
        "+example.com/foo=bar"
    ], [
        Tag(
            key: .init(clientOnly: true, vendor: .init(host: "example.com"), name: "foo"),
            value: "bar"
        )
    ])) func testTag(input: String, output: IRC.Tag) throws {
        #expect(try Tag.parser.parse(input) == output)
        #expect(try Tag.parser.print(output) == input)
    }
    
    @Test(arguments: zip([
        "wwalexander",
        "wwalexander!williamalexander@pumpkinseed-ionian.ts.net",
        "pumpkinseed-ionian.ts.net",
        "iridium.libera.chat",
    ], [
        "wwalexander",
        "wwalexander!williamalexander@pumpkinseed-ionian.ts.net",
        "pumpkinseed-ionian.ts.net",
        "iridium.libera.chat",
    ])) func testPrefix(input: String, output: Prefix) throws {
        #expect(try Prefix.parser.parse(input) == output)
        #expect(try Prefix.parser.print(output) == input)
    }
    
    @Test(arguments: zip([
        "NICK",
        "000",
    ], [
        Command.client("NICK"),
        Command.numeric(000),
    ])) func testCommand(input: String, output: Command) throws {
        #expect(try Command.parser.parse(input) == output)
        #expect(try Command.parser.print(output) == input)
    }
    
    @Test(arguments: zip([
        " foo bar :baz",
        " foo bar",
    ], [
        Params(middle: ["foo", "bar"], trailing: "baz"),
        Params(middle: ["foo", "bar"]),
    ])) func testParams(input: String, output: Params) throws {
        #expect(try Params.parser.parse(input) == output)
        #expect(try Params.parser.print(output) == input)
    }
    
    //USER william 0 * :William Alexander\r\n
    
    @Test(arguments: zip([
        ":iridium.libera.chat NOTICE * :*** Checking Ident",
    ], [
        Message(
            prefix: "iridium.libera.chat",
            command: "NOTICE",
            params: .init(
                middle: [
                    "*"
                ],
                trailing: "*** Checking Ident"
            )
        ),
    ])) func testMessage(input: String, output: Message) throws {
        #expect(try Message.parser.parse(input) == output)
        #expect(try Message.parser.print(output) == input)
    }
}
