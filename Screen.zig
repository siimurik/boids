const std = @import("std");
const stdout = std.io.getStdOut().writer();
const utf8Encode = std.unicode.utf8Encode;
const tty = @import("tty.zig");
const GRAPH_BASE = 0b101000_00000000;

data: [1024][2048]u8 = std.mem.zeroes([1024][2048]u8),
changed: [1024][2048]bool = std.mem.zeroes([1024][2048]bool),
stored_term_size: [2]usize = [_]usize{ 0, 0 },
last_term_size_fetch: i128 = 0,

pub fn set(self: *@This(), x: usize, y: usize, value: bool) void {
    const column = x / 2;
    const row = y / 4;
    const lx: u1 = @truncate(x - column * 2);
    const ly: u2 = @truncate(y - row * 4);
    const byte = dotByteOf(lx, ly);
    if (value) {
        self.data[row][column] |= byte;
    } else self.data[row][column] &= 0xff ^ byte;
    self.changed[row][column] = true;
}

fn termSize(self: *@This()) ![2]usize {
    const now = std.time.nanoTimestamp();
    if (now > self.last_term_size_fetch + 10_000_000) {
        var dims = try tty.getSize();
        if (dims[0] != self.stored_term_size[0] or dims[1] != self.stored_term_size[1])
            try stdout.print("\x1b[2J", .{});
        self.stored_term_size = dims;
        self.last_term_size_fetch = now;
        return dims;
    } else return self.stored_term_size;
}

pub fn size(self: *@This()) ![2]usize {
    var dims = try self.termSize();
    dims[0] *= 2;
    dims[1] *= 4;
    return dims;
}

pub fn flush(self: *@This()) !void {
    const dims = try self.termSize();
    var buf = [1]u8{0} ** 3;
    for (0..dims[0]) |x| {
        for (0..dims[1]) |y| {
            const byte = self.data[y][x];
            if (self.changed[y][x]) {
                self.changed[y][x] = false;
                if (byte == 0) {
                    buf = [3]u8{ ' ', 0, 0 };
                } else _ = try utf8Encode(GRAPH_BASE + @as(u21, byte), &buf);
                try stdout.print("\x1b[{};{}H{s}", .{ y + 1, x + 1, buf });
            }
        }
    }
}

fn dotByteOf(x: u1, y: u2) u8 {
    return switch (x) {
        0 => switch (y) {
            0 => 0b00000001,
            1 => 0b00000010,
            2 => 0b00000100,
            3 => 0b01000000,
        },
        1 => switch (y) {
            0 => 0b00001000,
            1 => 0b00010000,
            2 => 0b00100000,
            3 => 0b10000000,
        },
    };
}
