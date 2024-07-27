const std = @import("std");

const TokenType = enum {
    Integer,
    Float,
    Plus,
    Minus,
    Multiplication,
    Division,
    Left_Parentises,
    Right_Parentises,
};

const Token = struct {
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

const Lexer = struct {
    text: []const u8,
    cursor: u32,
    current_char: u8,

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
        var tokens = []Token{};

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
            }
        }

        return tokens;
    }
};

pub fn main() !void {
    const token = Token{ .token_type = TokenType.Integer, .value = "123" };
    token.print();
}
