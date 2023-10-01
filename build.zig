const std = @import("std");

pub fn build(b: *std.Build) void {
    // swap out the method you want to call depending on platform
    buildWeb(b);
}

fn buildWeb(b: *std.Build) void {
    const target = std.zig.CrossTarget{ .cpu_arch = .wasm32, .os_tag = .emscripten };

    const lib = b.addStaticLibrary(.{
        .name = "sdl-test",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = .Debug,
    });
    lib.linkLibC();
    lib.addIncludePath(.{ .path = "/Users/mak/dev/_SDKs/emsdk/upstream/emscripten/cache/sysroot/include" });
    b.installArtifact(lib);
}

fn buildIos(b: *std.Build) void {
    const target = std.zig.CrossTarget{ .cpu_arch = .aarch64, .os_tag = .ios };

    const lib = b.addStaticLibrary(.{
        .name = "sdl-test",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = .Debug,
    });
    b.sysroot = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk";
    lib.linkLibC();
    lib.addSystemIncludePath(.{ .path = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/include" });
    lib.addIncludePath(.{ .path = "ios/ios-template/include" });
    b.installArtifact(lib);

    // Normal image paths have a hierarchy, like "assets/snek.png", but iOS seems to use "snek.png" regardless of folder structure.
    // Is there a way to make this more consistent across platforms? Look up how other engines like LÖVE does this.
}

// TODO: buildAndroid
