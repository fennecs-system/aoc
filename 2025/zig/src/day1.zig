const std = @import("std");
const aoc = @import("aoc");

pub fn solve() !struct { i64, i64 } {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};
    const allocator = gpa.allocator();
    const buf = try aoc.readFile(allocator, "data/1.txt");

    const p1 = try solveP1(buf);
    const p2 = try solveP2(buf);
    allocator.free(buf);

    return .{ p1, p2 };
}

pub fn solveP1(buf: []const u8) !i64 {
    var current_position: i64 = 50;
    var num_zeros: i64 = 0;
    var op: i32 = -1;
    var current_num: i64 = 0;

    for (buf) |char| {
        if (char == '\n') {
            if (op == 1) {
                current_position = @mod(current_position + current_num, 100);
                if (current_position == 0) {
                    num_zeros += 1;
                }
                op = -1;
            } else if (op == 0) {
                current_position = @mod(current_position - current_num, 100);
                if (current_position == 0) {
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
            current_num = 10 * (current_num) + num;
        }
    }

    return num_zeros;
}

pub fn solveP2(buf: []const u8) !i64 {
    var current_position: i64 = 50;
    var new_position: i64 = 0;
    var num_crosses: i64 = 0;
    var num_zeros: i64 = 0;
    var op: i32 = -1;
    var current_num: i64 = 0;

    for (buf) |char| {
        if (char == '\n') {
            if (op == 1) {
                new_position = @mod(current_position + @rem(current_num, 100), 100);

                num_crosses = @divFloor(current_num, 100);

                // if new position < current, we looped around
                if (new_position == 0 or new_position <= current_position and current_position != 0) {
                    std.debug.print("Hit zero at {}, from {} adding {}\n", .{ new_position, current_position, current_num });

                    num_zeros += num_crosses + 1;
                    // std.debug.print("Num crosses {}\n", .{num_crosses + 1});
                } else if (num_crosses > 0) {
                    // std.debug.print("Crossed zero {} times from {} adding {}\n", .{ num_crosses, current_position, current_num });
                    num_zeros += num_crosses;
                }
                current_position = new_position;

                op = -1;
            } else if (op == 0) {
                new_position = @mod(current_position - @rem(current_num, 100), 100);
                num_crosses = @divFloor(current_num, 100);

                if (new_position == 0 or new_position >= current_position and current_position != 0) {
                    // std.debug.print("Hit zero at {}, from {} subtracting {}\n", .{ new_position, current_position, current_num });

                    num_zeros += num_crosses + 1;
                    // std.debug.print("Num crosses {}\n", .{num_crosses + 1});
                } else if (num_crosses > 0) {
                    // std.debug.print("Crossed zero {} times from {} subbing {}\n", .{ num_crosses, current_position, current_num });
                    num_zeros += num_crosses;
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
            current_num = 10 * (current_num) + num;
        }
    }

    return num_zeros;
}

test "day 1 p1 test" {
    const test_input: []const u8 = "L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82\n";
    const result = try solveP1(test_input);
    std.debug.print("Result: {}\n", .{result});
    //try std.testing.expect(result == 3);
}
