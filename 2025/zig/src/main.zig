const std = @import("std");
const aoc = @import("aoc");

pub fn main() !void {
    const x = aoc.add(1,2);
    std.debug.print("{d}\n", .{x});
}
