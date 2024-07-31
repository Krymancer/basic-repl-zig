const std = @import("std");
const Token = @import("token.zig").Token;
const TokenType = @import("token.zig").TokenType;
const Lexer = @import("lexer.zig").Lexer;

pub fn main() !void {
    const in = std.io.getStdIn();
    var buffer = std.io.bufferedReader(in.reader());
    var reader = buffer.reader();
    while (true) {
        std.debug.print("> ", .{});
        var input_buffer: [1024]u8 = undefined;
        const input = try reader.readUntilDelimiterOrEof(&input_buffer, '\n');

        if (input) |i| {
            var lexer = Lexer.init(i);
            const tokens = try lexer.tokenize();

            const iter = tokens.items;
            for (iter) |token| {
                token.print();
            }
        }
    }
}
