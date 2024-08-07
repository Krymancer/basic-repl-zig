const std = @import("std");
const Token = @import("token.zig").Token;
const TokenType = @import("token.zig").TokenType;

pub const AST = struct {
    current: u32,
    _type: []const u8,
    body: std.ArrayList(*Expression),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) @This() {
        return .{ .current = 0, ._type = "Program", .body = std.ArrayList(*Expression).init(allocator), .allocator = allocator };
    }

    pub fn next(self: *@This()) void {
        self.current = self.current + 1;
    }

    pub fn walk(self: *@This(), tokens: std.ArrayList(Token)) !*Expression {
        var token = tokens.items[self.current];

        if (token.token_type == TokenType.Integer) {
            self.next();

            const value = try std.fmt.parseInt(i64, token.value, 10);
            const expr = try self.allocator.create(Expression);
            expr.* = Expression{ .NumberLiteral = value };
            return expr;
        }

        if (token.token_type == TokenType.Left_Parentises) {
            self.next();
            token = tokens.items[self.current];

            var call_expr = try self.allocator.create(*Expression.CallExpression);
            call_expr.* = Expression.CallExpression{
                .name = token.value,
                .params = std.ArrayList(*Expression).init(self.allocator),
            };

            self.next();

            while (tokens.items[self.current].token_type != TokenType.Right_Parentises) {
                const arg_expr = try self.walk(tokens);
                try call_expr.params.append(arg_expr);
            }

            self.next();

            const expr = try self.allocator.create(*Expression);
            expr.* = Expression{ .CallExpression = call_expr };

            return expr;
        }

        return error.UnexpectedToken;
    }

    pub fn printExpression(expr: *Expression) void {
        const stdout = std.io.getStdOut().writer();
        switch (expr.*) {
            .NumberLiteral => |value| {
                _ = stdout.print("{} ", .{value});
            },
            .CallExpression => |call_expr| {
                _ = stdout.print("({} ", .{call_expr.name});
                for (call_expr.params.items) |param| {
                    printExpression(param);
                }
                _ = stdout.print(") ", .{});
            },
        }
    }
};

const Expression = union(enum) {
    NumberLiteral: i64,
    CallExpression: *CallExpression,

    const CallExpression = struct { name: []const u8, params: std.ArrayList(*Expression) };
};
