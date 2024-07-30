const std = @import("std");
const Token = @import("token.zig").Token;
const TokenType = @import("token.zig").TokenType;

pub const Lexer = struct {
    text: []const u8,
    cursor: u32,
    current_char: u8,

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    pub fn init(text: []const u8) Lexer {
        return Lexer{
            .text = text,
            .cursor = 0,
            .current_char = text[0],
        };
    }

    pub fn next(self: Lexer) void {
        self.cursor += 1;
        if (self.cursor < self.text.len) {
            self.current_char = self.text[self.cursor];
        } else {
            self.current_char = 0;
        }
    }

    pub fn tokenize(self: Lexer) []Token {
        var tokens = std.ArrayList(Token).init(allocator);

        while (self.current_char != 0) {
            if (self.current_char == ' ') {
                self.next();
            } else if (self.current_char == '\t') {
                self.next();
            } else if (self.current_char == '+') {
                tokens.append(Token.init(TokenType.Plus, "+"));
            } else if (self.current_char == '-') {
                tokens.append(Token.init(TokenType.Minus, "-"));
            } else if (self.current_char == '*') {
                tokens.append(Token.init(TokenType.Multiplication, "*"));
            } else if (self.current_char == '/') {
                tokens.append(Token.init(TokenType.Division, "/"));
            } else if (self.current_char == '(') {
                tokens.append(Token.init(TokenType.Left_Parentises, "("));
            } else if (self.current_char == ')') {
                tokens.append(Token.init(TokenType.Right_Parentises, ")"));
            } else if (std.ascii.isDigit(self.current_char)) {
                tokens.append(tokenize_number());
            }
        }

        return tokens;
    }

    pub fn tokenize_number() Token {
        // Only positive numbers for now
        return Token{ .token_type = TokenType.Integer, .value = "1" };
    }
};
