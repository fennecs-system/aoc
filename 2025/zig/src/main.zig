const std = @import("std");
const aoc = @import("aoc");

pub fn main() !void {
    const p1, const p2 = try aoc.day1();
    std.debug.print("p1 {} p2 {} \n", .{ p1, p2 });
}
