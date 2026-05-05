public enum IRCChannelMembership: Character, CaseIterable {
    case founder = "~"
    case protected = "&"
    case `operator` = "@"
    case halfop = "%"
}
