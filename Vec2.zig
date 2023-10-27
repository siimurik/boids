const std = @import("std");

x: f32,
y: f32,

pub fn zero() @This() {
    return @This(){ .x = 0, .y = 0 };
}

pub fn random(rng: std.rand.Random) @This() {
    var vec = @This(){
        .x = rng.float(f32) - 0.5,
        .y = rng.float(f32) - 0.5,
    };
    vec.normalize();
    return vec;
}

pub fn clone(self: *const @This()) @This() {
    return @This(){ .x = self.x, .y = self.y };
}

pub fn length(self: *const @This()) f32 {
    return @sqrt(self.x * self.x + self.y * self.y);
}

pub fn add(self: *@This(), other: *const @This()) void {
    self.x += other.x;
    self.y += other.y;
}

pub fn sub(self: *@This(), other: *const @This()) void {
    self.x -= other.x;
    self.y -= other.y;
}

pub fn mul(self: *@This(), by: f32) void {
    self.x *= by;
    self.y *= by;
}

pub fn div(self: *@This(), by: f32) void {
    self.x /= by;
    self.y /= by;
}

pub fn limit(self: *@This(), by: f32) void {
    if (self.length() <= by) return;
    self.normalize();
    self.mul(by);
}

pub fn normalize(self: *@This()) void {
    const len = self.length();
    if (len != 0) self.div(len);
}

pub fn distance(self: *const @This(), other: *const @This()) f32 {
    var diff = self.clone();
    diff.sub(other);
    return diff.length();
}
