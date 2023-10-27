const std = @import("std");
const stdout = std.io.getStdOut().writer();
const ArrayList = std.ArrayList;
const ChildProcess = std.ChildProcess;
const heap = @import("heap.zig");

pub fn enterRaw() !void {
    try call(&.{ "stty", "raw", "-echo" });
    try stdout.print("\x1b[?25l\x1b[2J", .{});
}

pub fn leaveRaw() !void {
    try call(&.{ "stty", "-raw", "echo" });
    try stdout.print("\x1b[?25h", .{});
}

pub fn getSize() ![2]usize {
    var out = try fetch(&.{ "stty", "size" });
    defer out.deinit();
    var delim: usize = 0;
    var end: usize = 0;
    for (out.items, 0..) |char, index| {
        if (char == ' ') {
            delim = index;
        } else if (char == '\n') end = index;
    }
    const width = try std.fmt.parseInt(usize, out.items[(delim + 1)..end], 10);
    const height = try std.fmt.parseInt(usize, out.items[0..delim], 10);
    return [2]usize{ width, height };
}

fn call(argv: []const []const u8) !void {
    var proc = ChildProcess.init(argv, heap.allocator);
    _ = try proc.spawnAndWait();
}

fn fetch(argv: []const []const u8) !ArrayList(u8) {
    var proc = ChildProcess.init(argv, heap.allocator);
    var out = ArrayList(u8).init(heap.allocator);
    var err = ArrayList(u8).init(heap.allocator);
    defer err.deinit();
    proc.stdout_behavior = .Pipe;
    proc.stderr_behavior = .Pipe;
    try proc.spawn();
    try proc.collectOutput(&out, &err, 64);
    _ = try proc.wait();
    return out;
}
