const std = @import("std");

pub const BaseError = struct {
    name: []const u8,
    details: []const u8,

    pub fn init(name: []const u8, details: []const u8) Error {
        return Error{
            .name = name,
            .details = details,
        };
    }

    pub fn print(self: Error) void {
        std.debug.print("{s}:{s}\n", .{ self.name, self.details });
    }
};


pub const IllegalCharacterError = struct {
    base_error: BaseError,

    pub fn init(name: []const u8, details: []const u8) IllegalCharacterError {
        return IllegalCharacterError {
            .base_error: Error.init(name, details),
        };
    }
}