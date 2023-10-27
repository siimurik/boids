const std = @import("std");
const stdin = std.io.getStdIn().reader();
const ArrayList = std.ArrayList;
const Screen = @import("Screen.zig");
const Boid = @import("Boid.zig");
const Vec2 = @import("Vec2.zig");
const heap = @import("heap.zig");
const tty = @import("tty.zig");

fn waitForKey() !void {
    while (true) {
        const byte = try stdin.readByte();
        if (byte == 3 or byte == 'q' or byte == 'Q') break;
    }
    try tty.leaveRaw();
    std.os.exit(0);
}

pub fn main() !void {
    _ = try std.Thread.spawn(.{}, waitForKey, .{});
    try tty.enterRaw();

    var screen = Screen{};

    var sfc = std.rand.Sfc64.init(@intCast(std.time.nanoTimestamp()));
    var random = sfc.random();

    var boids = ArrayList(Boid).init(heap.allocator);
    defer boids.deinit();
    for (0..1000) |_| {
        var boid = Boid.init();
        boid.position.x = random.float(f32) * 2000;
        boid.position.y = random.float(f32) * 2000;
        boid.velocity = Vec2.random(random);
        boid.velocity.mul(Boid.speed);
        try boids.append(boid);
    }

    while (true) {
        for (boids.items) |*boid| {
            boid.display(&screen, false);
        }
        for (boids.items) |*boid| {
            boid.steer(&boids.items);
        }
        for (boids.items) |*boid| {
            try boid.update(&screen);
            boid.display(&screen, true);
        }
        try screen.flush();
        std.time.sleep(10_000_000);
    }
}
