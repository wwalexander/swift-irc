/*
 https://datatracker.ietf.org/doc/html/rfc1459.html#section-2.3.1
 https://ircv3.net/specs/extensions/message-tags.html#format
 <message>       ::= ['@' <tags> <SPACE>] [':' <prefix> <SPACE> ] <command> [params] <crlf>
 <tags>          ::= <tag> [';' <tag>]*
 <tag>           ::= <key> ['=' <escaped_value>]
 <key>           ::= [ <client_prefix> ] [ <vendor> '/' ] <key_name>
 <client_prefix> ::= '+'
 <key_name>      ::= <non-empty sequence of ascii letters, digits, hyphens ('-')>
 <escaped_value> ::= <sequence of zero or more utf8 characters except NUL, CR, LF, semicolon (`;`) and SPACE>
 <vendor>        ::= <host>
 
 The mapping between characters in tag values and their representation in <escaped value> is defined as follows:

 Character       Sequence in <escaped value>
 ; (semicolon)   \: (backslash and colon)
 SPACE           \s
 \               \\
 CR              \r
 LF              \n
 all others      the character itself
 
 <prefix>        ::= <servername> | <nick> [ '!' <user> ] [ '@' <host> ]
 <command>       ::= <letter> { <letter> } | <number> <number> <number>
 <SPACE>         ::= ' ' { ' ' }
 <params>        ::= <SPACE> [ ':' <trailing> | <middle> <params> ]
 <middle>        ::= <Any *non-empty* sequence of octets not including SPACE or NUL or CR or LF, the first of which may not be ':'>
 <trailing>      ::= <Any, possibly *empty*, sequence of octets not including NUL or CR or LF>
 <crlf>          ::= CR LF
 
 <target>        ::= <to> [ "," <target> ]
 <to>            ::= <channel> | <user> '@' <servername> | <nick> | <mask>
 <channel>       ::= ('#' | '&') <chstring>
 <servername>    ::= <host>
 <host>          ::= see RFC 952 [DNS:4] for details on allowed hostnames
 <nick>          ::= <letter> { <letter> | <number> | <special> }
 <mask>          ::= ('#' | '$') <chstring>
 <chstring>      ::= <any 8bit code except SPACE, BELL, NUL, CR, LF and comma (',')>
 
 <user>          ::= <nonwhite> { <nonwhite> }
 <letter>        ::= 'a' ... 'z' | 'A' ... 'Z'
 <number>        ::= '0' ... '9'
 <special>       ::= '-' | '[' | ']' | '\' | '`' | '^' | '{' | '}'
 <nonwhite>      ::= <any 8bit code except SPACE (0x20), NUL (0x0), CR (0xd), and LF (0xa)>
 
 https://www.rfc-editor.org/rfc/rfc952#page-5
 https://www.rfc-editor.org/rfc/rfc1123.html#page-13
 <hname>         ::= <name>*["."<name>]
 <name>          ::= <let>[*[<let-or-digit-or-hyphen>]<let-or-digit>]
 
 The syntax of a legal Internet host name was specified in RFC-952
 [DNS:4].  One aspect of host name syntax is hereby changed: the
 restriction on the first character is relaxed to allow either a
 letter or a digit.  Host software MUST support this more liberal
 syntax.
 */
