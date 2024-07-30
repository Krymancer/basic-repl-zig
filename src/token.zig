const std = @import("std");

pub const TokenType = enum {
    Integer,
    Float,
    Plus,
    Minus,
    Multiplication,
    Division,
    Left_Parentises,
    Right_Parentises,
};

pub const Token = struct {
    token_type: TokenType,
    value: []const u8,

    pub fn init(token_type: TokenType, value: []const u8) Token {
        return Token{
            .token_type = token_type,
            .value = value,
        };
    }

    pub fn print(self: Token) void {
        std.debug.print("{s}:{s}", .{ @tagName(self.token_type), self.value });
    }
};
