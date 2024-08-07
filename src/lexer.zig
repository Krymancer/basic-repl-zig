const std = @import("std");
const Token = @import("token.zig").Token;
const TokenType = @import("token.zig").TokenType;

pub const Lexer = struct {
    text: []const u8,
    cursor: u32,
    current_char: u8,
    allocator: std.mem.Allocator,

    pub fn init(text: []const u8, allocator: std.mem.Allocator) @This() {
        return .{ .text = text, .cursor = 0, .current_char = text[0], .allocator = allocator };
    }

    pub fn next(self: *@This()) void {
        self.cursor = self.cursor + 1;
        if (self.cursor < self.text.len - 1) {
            self.current_char = self.text[self.cursor];
        } else {
            self.current_char = 0;
        }
    }

    pub fn tokenize(self: *@This()) !std.ArrayList(Token) {
        var tokens = std.ArrayList(Token).init(self.allocator);

        while (self.current_char != 0) {
            if (std.ascii.isWhitespace(self.current_char)) {
                self.next();
            } else if (self.current_char == '(') {
                try tokens.append(Token.init(TokenType.Left_Parentises, "("));
                self.next();
            } else if (self.current_char == ')') {
                try tokens.append(Token.init(TokenType.Right_Parentises, ")"));
                self.next();
            } else if (std.ascii.isDigit(self.current_char)) {
                try tokens.append(try self.tokenize_number());
            } else if (std.ascii.isAlphabetic(self.current_char)) {
                try tokens.append(try self.tokenize_text());
            } else {
                std.debug.print("[ERROR] Not expected: '{c}'\n", .{self.current_char});
                return tokens;
            }
        }

        return tokens;
    }

    pub fn tokenize_number(self: *@This()) !Token {
        var dot_count: u32 = 0;
        var number = std.ArrayList(u8).init(self.allocator);

        while (self.current_char != 0 and (std.ascii.isDigit(self.current_char) or self.current_char == '.')) {
            if (self.current_char == '.') {
                if (dot_count == 1) {
                    break;
                }

                dot_count = dot_count + 1;
                try number.append(self.current_char);
            } else {
                try number.append(self.current_char);
            }
            self.next();
        }

        const value = number.items;

        if (dot_count == 0) {
            return Token{ .token_type = TokenType.Integer, .value = value };
        } else {
            return Token{ .token_type = TokenType.Float, .value = value };
        }
    }

    pub fn tokenize_text(self: *@This()) !Token {
        var text = std.ArrayList(u8).init(self.allocator);

        while (self.current_char != 0 and !std.ascii.isWhitespace(self.current_char)) {
            try text.append(self.current_char);
            self.next();
        }

        const value = text.items;
        return Token{ .token_type = TokenType.Text, .value = value };
    }
};
