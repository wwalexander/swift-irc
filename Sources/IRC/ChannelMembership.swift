public enum ChannelMembership: Character, CaseIterable {
    case founder = "~"
    case protected = "&"
    case `operator` = "@"
    case halfop = "%"
}
