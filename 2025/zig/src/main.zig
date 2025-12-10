const std = @import("std");
const day1 = @import("day1");
const day2 = @import("day2");

pub fn main() !void {
    const p1, const p2 = try day2.solve();
    std.debug.print("p1 {} p2 {} \n", .{ p1, p2 });
}
