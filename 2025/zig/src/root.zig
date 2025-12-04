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

pub fn day1() !i64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};
    const allocator = gpa.allocator();
    const buf = try readFile(allocator, "data/1.txt");

    const result = try day1P1(buf);
    allocator.free(buf);
    return result;
}

pub fn day1P1(buf: []const u8) !i64 {
    var current_position: i64 = 50;
    var num_zeros: i64 = 0;
    var op: i32 = -1;
    var current_num: i64 = 0;

    for (buf) |char| {
        if (char == '\n') {
            if (op == 1) {
                current_position = @mod(current_position + current_num, 100);
                if (current_position == 0) {
                    std.debug.print("Hit zero at addition of {}\n", .{current_num});
                    num_zeros += 1;
                }
                op = -1;
            } else if (op == 0) {
                current_position = @mod(current_position - current_num, 100);
                if (current_position == 0) {
                    std.debug.print("Hit zero at subtraction of {}\n", .{current_num});
                    num_zeros += 1;
                }
                op = -1;
            }
            continue;
        }
        if (char == 'R') {
            current_num = 0;
            op = 1;
            continue;
        }
        if (char == 'L') {
            current_num = 0;
            op = 0;
            continue;
        }
        if (op >= 0) {
            const num: i64 = char - '0';
            std.debug.print("Num char: {}, num: {}\n", .{ char, num });
            current_num = 10 * (current_num) + num;
            std.debug.print("Current num: {}\n", .{current_num});
        }
    }

    return num_zeros;
}

pub fn day1P2(buf: []const u8) !i64 {
    var current_position: i64 = 50;
    var new_position = 0;
    var num_zeros: i64 = 0;
    var op: i32 = -1;
    var current_num: i64 = 0;

    for (buf) |char| {
        if (char == '\n') {
            if (op == 1) {
                new_position = @mod(current_position + current_num, 100);

                // if new position < current, we looped around
                if (current_position == 0 or new_position < current_position) {
                    std.debug.print("Hit zero at addition of {}\n", .{current_num});
                    num_zeros += 1;
                }
                current_position = new_position;

                op = -1;
            } else if (op == 0) {
                new_position = @mod(current_position - current_num, 100);

                if (current_position == 0 or new_position > current_position) {
                    std.debug.print("Hit zero at subtraction of {}\n", .{current_num});
                    num_zeros += 1;
                }

                current_position = new_position;
                op = -1;
            }
            continue;
        }
        if (char == 'R') {
            current_num = 0;
            op = 1;
            continue;
        }
        if (char == 'L') {
            current_num = 0;
            op = 0;
            continue;
        }
        if (op >= 0) {
            const num: i64 = char - '0';
            std.debug.print("Num char: {}, num: {}\n", .{ char, num });
            current_num = 10 * (current_num) + num;
            std.debug.print("Current num: {}\n", .{current_num});
        }
    }

    return num_zeros;
}

test "day 1 p1 test" {
    const test_input: []const u8 = "L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82\n";
    const result = try day1P1(test_input);
    std.debug.print("Result: {}\n", .{result});
    //try std.testing.expect(result == 3);
}
