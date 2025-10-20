const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const sdl_dep = b.dependency("sdl", .{
        .target = target,
        .optimize = optimize,
    });
    const sdl_lib = sdl_dep.artifact("SDL3");
    const lib_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });
    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "SDL_image",
        .root_module = lib_mod,
    });
    lib.root_module.linkLibrary(sdl_lib);

    lib.addIncludePath(b.path("SDL_image/include"));
    lib.addIncludePath(b.path("SDL_image/src"));
    lib.addCSourceFiles(.{.files = &.{
        "SDL_image/src/IMG.c",
        "SDL_image/src/IMG_bmp.c",
    }});
    lib.installHeader(b.path("SDL_image/include/SDL3_image/SDL_image.h"), "SDL3_image/SDL_image.h");
    b.installArtifact(lib);
}
