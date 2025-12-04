const std = @import("std");

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

pub fn day1() { 
   return 0; 
}


test "basic add functionality" {
    try std.testing.expect(add(3, 7) == 10);
}
