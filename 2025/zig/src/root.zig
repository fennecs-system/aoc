const std = @import("std");

pub fn readFile(allocator: std.mem.Allocator, path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    const stat = try file.stat();
    const size = stat.size;
    defer file.close();

    const buf = try allocator.alloc(u8, size);
    _ = try file.read(buf);
    return buf;
}
