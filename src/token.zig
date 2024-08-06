const std = @import("std");

pub const TokenType = enum { Integer, Float, Left_Parentises, Right_Parentises, Text, EOF };

pub const Token = struct {
    token_type: TokenType,
    value: []const u8,

    pub fn init(token_type: TokenType, value: []const u8) @This() {
        return @This(){
            .token_type = token_type,
            .value = value,
        };
    }

    pub fn print(self: @This()) void {
        std.debug.print("[{s}:{s}]\n", .{ @tagName(self.token_type), self.value });
    }
};
