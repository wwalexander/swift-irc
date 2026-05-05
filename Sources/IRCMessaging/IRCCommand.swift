import Foundation
import Parsing

public enum IRCCommand: Sendable, Equatable {
    case client(ClientCommand)
    case numeric(NumericCommand)
}

extension IRCCommand: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        OneOf {
            ClientCommand.parser.map(.case(client))
            NumericCommand.parser.map(.case(numeric))
        }
    }
}

public struct ClientCommand: Sendable {
    let rawValue: String
}

extension ClientCommand: ParsePrintable {
    public static var parser: some ParserPrinter<Substring, Self> {
        Parse(.string.map(.memberwise(Self.init(rawValue:)))) {
            Prefix(1...) {
                $0.isLetter
            }
        }
    }
}

extension ClientCommand: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue.caseInsensitiveCompare(rhs.rawValue) == .orderedSame
    }
}

extension ClientCommand: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        try! self.init(parsing: value)
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

public struct NumericCommandError: Error {
    public let numericCommand: NumericCommand
}

public extension ClientCommand {
    static let cap         : Self = "CAP"
    static let authenticate: Self = "AUTHENTICATE"
    static let pass        : Self = "PASS"
    static let nick        : Self = "NICK"
    static let user        : Self = "USER"
    static let ping        : Self = "PING"
    static let pong        : Self = "PONG"
    static let oper        : Self = "OPER"
    static let quit        : Self = "QUIT"
    static let error       : Self = "ERROR"
    static let join        : Self = "JOIN"
    static let part        : Self = "PART"
    static let topic       : Self = "TOPIC"
    static let names       : Self = "NAMES"
    static let list        : Self = "LIST"
    static let invite      : Self = "INVITE"
    static let kick        : Self = "KICK"
    static let motd        : Self = "MOTD"
    static let version     : Self = "VERSION"
    static let admin       : Self = "ADMIN"
    static let connect     : Self = "CONNECT"
    static let lUsers      : Self = "LUSERS"
    static let time        : Self = "TIME"
    static let stats       : Self = "STATS"
    static let help        : Self = "HELP"
    static let info        : Self = "INFO"
    static let mode        : Self = "MODE"
    static let privMsg     : Self = "PRIVMSG"
    static let notice      : Self = "NOTICE"
    static let who         : Self = "WHO"
    static let whoIs       : Self = "WHOIS"
    static let whoWas      : Self = "WHOWAS"
    static let kill        : Self = "KILL"
    static let rehash      : Self = "REHASH"
    static let restart     : Self = "RESTART"
    static let sQuit       : Self = "SQUIT"
    static let away        : Self = "AWAY"
    static let links       : Self = "LINKS"
    static let userHost    : Self = "USERHOST"
    static let wallops     : Self = "WALLOPS"
}

public extension NumericCommand {
    static let welcome          : Self = 001
    static let yourHost         : Self = 002
    static let created          : Self = 003
    static let myInfo           : Self = 004
    static let iSupport         : Self = 005
    static let bounce           : Self = 010
    static let statsCommands    : Self = 212
    static let endOfStats       : Self = 219
    static let uModeIs          : Self = 221
    static let statsUptime      : Self = 242
    static let lUserClient      : Self = 251
    static let lUserOp          : Self = 252
    static let lUserUnknown     : Self = 253
    static let lUserChannels    : Self = 254
    static let lUserMe          : Self = 255
    static let lAdminMe         : Self = 256
    static let adminLoc1        : Self = 257
    static let adminLoc2        : Self = 258
    static let adminEmail       : Self = 259
    static let tryAgain         : Self = 263
    static let localUsers       : Self = 265
    static let globalUsers      : Self = 266
    static let whoIsCertFP      : Self = 276
    static let none             : Self = 300
    static let away             : Self = 301
    static let userHost         : Self = 302
    static let unAway           : Self = 305
    static let nowAway          : Self = 306
    static let whoIsRegNick     : Self = 307
    static let whoIsUser        : Self = 311
    static let whoIsServer      : Self = 312
    static let whoIsOperator    : Self = 313
    static let whoWasUser       : Self = 314
    static let endOfWho         : Self = 315
    static let whoIsIdle        : Self = 317
    static let endOfWhoIs       : Self = 318
    static let whoIsChannels    : Self = 319
    static let whoIsSpecial     : Self = 320
    static let listStart        : Self = 321
    static let list             : Self = 322
    static let listEnd          : Self = 323
    static let channelModeIs    : Self = 324
    static let creationTime     : Self = 329
    static let whoIsAccount     : Self = 330
    static let noTopic          : Self = 331
    static let topic            : Self = 332
    static let topicWhoTime     : Self = 333
    static let inviteList       : Self = 336
    static let endOfInviteList  : Self = 337
    static let whoIsActually    : Self = 338
    static let inviting         : Self = 341
    static let invExList        : Self = 346
    static let endOfInvExList   : Self = 347
    static let exceptList       : Self = 348
    static let endOfExceptList  : Self = 349
    static let version          : Self = 351
    static let whoReply         : Self = 352
    static let namReply         : Self = 353
    static let links            : Self = 364
    static let endOfLinks       : Self = 365
    static let endOfNames       : Self = 366
    static let banList          : Self = 367
    static let endOfBanList     : Self = 368
    static let endOfWhoWas      : Self = 369
    static let info             : Self = 371
    static let motd             : Self = 372
    static let endOfInfo        : Self = 374
    static let motdStart        : Self = 375
    static let endOfMOTD        : Self = 376
    static let whoIsHost        : Self = 378
    static let whoIsModes       : Self = 379
    static let youreOper        : Self = 381
    static let rehashing        : Self = 382
    static let time             : Self = 391
    static let startTLS         : Self = 670
    static let whoIsSecure      : Self = 671
    static let helpStart        : Self = 704
    static let helpTxt          : Self = 705
    static let endOfHelp        : Self = 706
    static let loggedIn         : Self = 900
    static let loggedOut        : Self = 901
    static let saslMechs        : Self = 908
}

public extension NumericCommand {
    static let unknownError     : Self = 400
    static let noSuchNick       : Self = 401
    static let noSuchServer     : Self = 402
    static let noSuchChannel    : Self = 403
    static let cannotSendToChan : Self = 404
    static let tooManyChannels  : Self = 405
    static let wasNoSuchNick    : Self = 406
    static let noOrigin         : Self = 409
    static let noRecipient      : Self = 411
    static let noTextToSend     : Self = 412
    static let inputTooLong     : Self = 417
    static let unknownCommand   : Self = 421
    static let noMOTD           : Self = 422
    static let noNicknameGiven  : Self = 431
    static let erroneousNickname: Self = 432
    static let nicknameInUse    : Self = 433
    static let nickCollision    : Self = 436
    static let userNotInChannel : Self = 441
    static let notOnChannel     : Self = 442
    static let userOnChannel    : Self = 443
    static let notRegistered    : Self = 451
    static let needMoreParams   : Self = 461
    static let alreadyRegistered: Self = 462
    static let passwdMismatch   : Self = 464
    static let youreBannedCreep : Self = 465
    static let channelIsFull    : Self = 471
    static let unknownMode      : Self = 472
    static let inviteOnlyChan   : Self = 473
    static let bannedFromChan   : Self = 474
    static let badChannelKey    : Self = 475
    static let badChanMask      : Self = 476
    static let noPrivileges     : Self = 481
    static let chanOPrivsNeeded : Self = 482
    static let cantKillServer   : Self = 483
    static let noOperHost       : Self = 491
    static let uModeUnknownFlag : Self = 501
    static let usersDontMatch   : Self = 502
    static let helpNotFound     : Self = 524
    static let invalidKey       : Self = 525
    static let startTLSFailed   : Self = 691
    static let invalidModeParam : Self = 696
    static let noPrivs          : Self = 723
    static let nickLocked       : Self = 902
    static let saslFail         : Self = 904
    static let saslTooLong      : Self = 905
    static let saslAborted      : Self = 906
    static let saslAlready      : Self = 907
}


