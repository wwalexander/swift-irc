import Parsing

public enum Command: Sendable, Equatable {
    case client(ClientCommand)
    case numeric(NumericCommand)
}

extension Command: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        OneOf {
            ClientCommand.parser.map(.case(client))
            NumericCommand.parser.map(.case(numeric))
        }
    }
}

public struct ClientCommand: Sendable {
    let value: String
}

extension ClientCommand: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(value:)))) {
            Prefix(1...) {
                $0.isLetter
            }
        }
    }
}

extension ClientCommand: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value.caseInsensitiveCompare(rhs.value) == .orderedSame
    }
}

extension ClientCommand: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value[...])
    }
}

public struct NumericCommand: Sendable, Equatable {
    let value: Int
}

extension NumericCommand: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.memberwise(Self.init(value:))) {
            Digits(3)
        }
    }
}

extension NumericCommand: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = try! Self.parser.parse("\(value)")
    }
}

extension Command {
    public static let cap         : Command = .client("CAP")
    public static let authenticate: Command = .client("AUTHENTICATE")
    public static let pass        : Command = .client("PASS")
    public static let nick        : Command = .client("NICK")
    public static let user        : Command = .client("USER")
    public static let ping        : Command = .client("PING")
    public static let pong        : Command = .client("PONG")
    public static let oper        : Command = .client("OPER")
    public static let quit        : Command = .client("QUIT")
    public static let error       : Command = .client("ERROR")
    public static let join        : Command = .client("JOIN")
    public static let part        : Command = .client("PART")
    public static let topic       : Command = .client("TOPIC")
    public static let names       : Command = .client("NAMES")
    public static let list        : Command = .client("LIST")
    public static let invite      : Command = .client("INVITE")
    public static let kick        : Command = .client("KICK")
    public static let motd        : Command = .client("MOTD")
    public static let version     : Command = .client("VERSION")
    public static let admin       : Command = .client("ADMIN")
    public static let connect     : Command = .client("CONNECT")
    public static let lUsers      : Command = .client("LUSERS")
    public static let time        : Command = .client("TIME")
    public static let stats       : Command = .client("STATS")
    public static let help        : Command = .client("HELP")
    public static let info        : Command = .client("INFO")
    public static let mode        : Command = .client("MODE")
    public static let privMsg     : Command = .client("PRIVMSG")
    public static let notice      : Command = .client("NOTICE")
    public static let who         : Command = .client("WHO")
    public static let whoIs       : Command = .client("WHOIS")
    public static let whoWas      : Command = .client("WHOWAS")
    public static let kill        : Command = .client("KILL")
    public static let rehash      : Command = .client("REHASH")
    public static let restart     : Command = .client("RESTART")
    public static let sQuit       : Command = .client("SQUIT")
    public static let away        : Command = .client("AWAY")
    public static let links       : Command = .client("LINKS")
    public static let userHost    : Command = .client("USERHOST")
    public static let wallops     : Command = .client("WALLOPS")
    
    public enum Replies {
        public static let welcome          : Command = .numeric(001)
        public static let yourHost         : Command = .numeric(002)
        public static let created          : Command = .numeric(003)
        public static let myInfo           : Command = .numeric(004)
        public static let iSupport         : Command = .numeric(005)
        public static let bounce           : Command = .numeric(010)
        public static let statsCommands    : Command = .numeric(212)
        public static let endOfStats       : Command = .numeric(219)
        public static let uModeIs          : Command = .numeric(221)
        public static let statsUptime      : Command = .numeric(242)
        public static let lUserClient      : Command = .numeric(251)
        public static let lUserOp          : Command = .numeric(252)
        public static let lUserUnknown     : Command = .numeric(253)
        public static let lUserChannels    : Command = .numeric(254)
        public static let lUserMe          : Command = .numeric(255)
        public static let lAdminMe         : Command = .numeric(256)
        public static let adminLoc1        : Command = .numeric(257)
        public static let adminLoc2        : Command = .numeric(258)
        public static let adminEmail       : Command = .numeric(259)
        public static let tryAgain         : Command = .numeric(263)
        public static let localUsers       : Command = .numeric(265)
        public static let globalUsers      : Command = .numeric(266)
        public static let whoIsCertFP      : Command = .numeric(276)
        public static let none             : Command = .numeric(300)
        public static let away             : Command = .numeric(301)
        public static let userHost         : Command = .numeric(302)
        public static let unAway           : Command = .numeric(305)
        public static let nowAway          : Command = .numeric(306)
        public static let whoIsRegNick     : Command = .numeric(307)
        public static let whoIsUser        : Command = .numeric(311)
        public static let whoIsServer      : Command = .numeric(312)
        public static let whoIsOperator    : Command = .numeric(313)
        public static let whoWasUser       : Command = .numeric(314)
        public static let endOfWho         : Command = .numeric(315)
        public static let whoIsIdle        : Command = .numeric(317)
        public static let endOfWhoIs       : Command = .numeric(318)
        public static let whoIsChannels    : Command = .numeric(319)
        public static let whoIsSpecial     : Command = .numeric(320)
        public static let listStart        : Command = .numeric(321)
        public static let list             : Command = .numeric(322)
        public static let listEnd          : Command = .numeric(323)
        public static let channelModeIs    : Command = .numeric(324)
        public static let creationTime     : Command = .numeric(329)
        public static let whoIsAccount     : Command = .numeric(330)
        public static let noTopic          : Command = .numeric(331)
        public static let topic            : Command = .numeric(332)
        public static let topicWhoTime     : Command = .numeric(333)
        public static let inviteList       : Command = .numeric(336)
        public static let endOfInviteList  : Command = .numeric(337)
        public static let whoIsActually    : Command = .numeric(338)
        public static let inviting         : Command = .numeric(341)
        public static let invExList        : Command = .numeric(346)
        public static let endOfInvExList   : Command = .numeric(347)
        public static let exceptList       : Command = .numeric(348)
        public static let endOfExceptList  : Command = .numeric(349)
        public static let version          : Command = .numeric(351)
        public static let whoReply         : Command = .numeric(352)
        public static let namReply         : Command = .numeric(353)
        public static let links            : Command = .numeric(364)
        public static let endOfLinks       : Command = .numeric(365)
        public static let endOfNames       : Command = .numeric(366)
        public static let banList          : Command = .numeric(367)
        public static let endOfBanList     : Command = .numeric(368)
        public static let endOfWhoWas      : Command = .numeric(369)
        public static let info             : Command = .numeric(371)
        public static let motd             : Command = .numeric(372)
        public static let endOfInfo        : Command = .numeric(374)
        public static let motdStart        : Command = .numeric(375)
        public static let endOfMOTD        : Command = .numeric(376)
        public static let whoIsHost        : Command = .numeric(378)
        public static let whoIsModes       : Command = .numeric(379)
        public static let youreOper        : Command = .numeric(381)
        public static let rehashing        : Command = .numeric(382)
        public static let time             : Command = .numeric(391)
        public static let startTLS         : Command = .numeric(670)
        public static let whoIsSecure      : Command = .numeric(671)
        public static let helpStart        : Command = .numeric(704)
        public static let helpTxt          : Command = .numeric(705)
        public static let endOfHelp        : Command = .numeric(706)
        public static let loggedIn         : Command = .numeric(900)
        public static let loggedOut        : Command = .numeric(901)
        public static let saslMechs        : Command = .numeric(908)
    }

    public enum Errors {
        public static let unknownError     : Command = .numeric(400)
        public static let noSuchNick       : Command = .numeric(401)
        public static let noSuchServer     : Command = .numeric(402)
        public static let noSuchChannel    : Command = .numeric(403)
        public static let cannotSendToChan : Command = .numeric(404)
        public static let tooManyChannels  : Command = .numeric(405)
        public static let wasNoSuchNick    : Command = .numeric(406)
        public static let noOrigin         : Command = .numeric(409)
        public static let noRecipient      : Command = .numeric(411)
        public static let noTextToSend     : Command = .numeric(412)
        public static let inputTooLong     : Command = .numeric(417)
        public static let unknownCommand   : Command = .numeric(421)
        public static let noMOTD           : Command = .numeric(422)
        public static let noNicknameGiven  : Command = .numeric(431)
        public static let erroneousNickname: Command = .numeric(432)
        public static let nicknameInUse    : Command = .numeric(433)
        public static let nickCollision    : Command = .numeric(436)
        public static let userNotInChannel : Command = .numeric(441)
        public static let notOnChannel     : Command = .numeric(442)
        public static let userOnChannel    : Command = .numeric(443)
        public static let notRegistered    : Command = .numeric(451)
        public static let needMoreParams   : Command = .numeric(461)
        public static let alreadyRegistered: Command = .numeric(462)
        public static let passwdMismatch   : Command = .numeric(464)
        public static let youreBannedCreep : Command = .numeric(465)
        public static let channelIsFull    : Command = .numeric(471)
        public static let unknownMode      : Command = .numeric(472)
        public static let inviteOnlyChan   : Command = .numeric(473)
        public static let bannedFromChan   : Command = .numeric(474)
        public static let badChannelKey    : Command = .numeric(475)
        public static let badChanMask      : Command = .numeric(476)
        public static let noPrivileges     : Command = .numeric(481)
        public static let chanOPrivsNeeded : Command = .numeric(482)
        public static let cantKillServer   : Command = .numeric(483)
        public static let noOperHost       : Command = .numeric(491)
        public static let uModeUnknownFlag : Command = .numeric(501)
        public static let usersDontMatch   : Command = .numeric(502)
        public static let helpNotFound     : Command = .numeric(524)
        public static let invalidKey       : Command = .numeric(525)
        public static let startTLS         : Command = .numeric(691)
        public static let invalidModeParam : Command = .numeric(696)
        public static let noPrivs          : Command = .numeric(723)
        public static let nickLocked       : Command = .numeric(902)
        public static let saslFail         : Command = .numeric(904)
        public static let saslTooLong      : Command = .numeric(905)
        public static let saslAborted      : Command = .numeric(906)
        public static let saslAlready      : Command = .numeric(907)
    }
}
