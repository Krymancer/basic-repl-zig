const std = @import("std");

pub const AST = struct {
    current: u32,
    _type: []const u8,
    body: []const u8,
    allocator: std.mem.Allocator,

    pub fn init(self: @This(), allocator: std.mem.Allocator) @This() {
        return .{ .current = 0, ._type = "Program", .body = self.walk(), .allocator = allocator };
    }

    fn walk(self: AST) void {
        return self;
    }
};

pub fn Expression(comptime T: type, comptime name: []const u8) type {
    return struct {
        name: []const u8,
        value: T,

        pub fn init(value: T) @This() {
            return .{ .name = name, .value = value };
        }
    };
}
