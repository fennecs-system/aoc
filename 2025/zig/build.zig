const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const aoc = b.addModule("aoc", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });

    const day1 = b.addModule("day1", .{ .root_source_file = b.path("src/day1.zig"), .target = target, .imports = &.{.{ .name = "aoc", .module = aoc }} });

    const day2 = b.addModule("day2", .{ .root_source_file = b.path("src/day2.zig"), .target = target, .imports = &.{.{ .name = "aoc", .module = aoc }} });

    const exe = b.addExecutable(.{
        .name = "aoc",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "aoc", .module = aoc }, .{ .name = "day1", .module = day1 }, .{ .name = "day2", .module = day2 } },
        }),
    });

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const mod_tests = b.addTest(.{
        .root_module = aoc,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);

    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });

    const run_exe_tests = b.addRunArtifact(exe_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_exe_tests.step);
}
