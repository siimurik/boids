const std = @import("std");
const Screen = @import("Screen.zig");
const Vec2 = @import("Vec2.zig");

pub const range = 10;
pub const speed = 1;
pub const max_acceleration = 0.3;

position: Vec2 = Vec2.zero(),
velocity: Vec2 = Vec2.zero(),
acceleration: Vec2 = Vec2.zero(),

pub fn init() @This() {
    return @This(){};
}

pub fn steer(self: *@This(), boids: *const []@This()) void {
    self.acceleration = Vec2.zero();
    var align_force = Vec2.zero();
    var cohesion_force = Vec2.zero();
    var separation_force = Vec2.zero();
    var neighbor_count: usize = 0;
    for (boids.*) |boid| {
        const distance = self.position.distance(&boid.position);
        if (&boid == self or distance > range) continue;
        neighbor_count += 1;
        align_force.add(&boid.velocity);
        cohesion_force.add(&boid.position);
        var push = self.position.clone();
        push.sub(&boid.position);
        push.div(if (distance == 0) std.math.floatMin(f32) else distance);
        separation_force.add(&push);
    }
    if (neighbor_count == 0) return;
    align_force.normalize();
    align_force.mul(speed);
    align_force.sub(&self.velocity);
    align_force.limit(max_acceleration);
    cohesion_force.div(@floatFromInt(neighbor_count));
    cohesion_force.sub(&self.position);
    cohesion_force.normalize();
    cohesion_force.mul(speed);
    cohesion_force.sub(&self.velocity);
    cohesion_force.limit(max_acceleration);
    separation_force.normalize();
    separation_force.mul(speed);
    separation_force.sub(&self.velocity);
    separation_force.limit(max_acceleration);
    self.acceleration.add(&align_force);
    self.acceleration.add(&cohesion_force);
    self.acceleration.add(&separation_force);
}

pub fn update(self: *@This(), screen: *Screen) !void {
    self.position.add(&self.velocity);
    self.velocity.add(&self.acceleration);
    self.velocity.limit(speed);
    try self.loop(screen);
}

pub fn display(self: *@This(), screen: *Screen, value: bool) void {
    const x: usize = @intFromFloat(@round(self.position.x));
    const y: usize = @intFromFloat(@round(self.position.y));
    screen.set(x, y, value);
}

fn loop(self: *@This(), screen: *Screen) !void {
    const intDims = try screen.size();
    const dims = Vec2{
        .x = @floatFromInt(intDims[0]),
        .y = @floatFromInt(intDims[1]),
    };
    if (self.position.x >= dims.x) {
        self.position.x -= dims.x;
    } else if (self.position.x < 0) {
        self.position.x += dims.x;
    }
    if (self.position.y >= dims.y) {
        self.position.y -= dims.y;
    } else if (self.position.y < 0) {
        self.position.y += dims.y;
    }
}
