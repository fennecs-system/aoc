const std = @import("std");
const aoc = @import("aoc");

pub fn main() !void {
    const x = try aoc.day1();
    std.debug.print("{}\n", .{x});
}
