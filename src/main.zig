const std = @import("std");
const Token = @import("token.zig").Token;
const TokenType = @import("token.zig").TokenType;

pub fn main() !void {
    const token = Token{ .token_type = TokenType.Integer, .value = "123" };
    token.print();
}
