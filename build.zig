const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const sdl_dep = b.dependency("sdl", .{
        .target = target,
        .optimize = optimize,
    });
    const sdl_lib = sdl_dep.artifact("SDL3");


    const lib_dep = b.dependency("SDL_image", .{});
    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "SDL_image",
        .root_module = b.addModule("SDL_image_2", .{.target = target, .optimize = optimize}),
    });
    lib.root_module.linkLibrary(sdl_lib);

    const png_dep = b.dependency("libpng", .{
        .target = target,
        .optimize = optimize,
    });
    const png_lib = png_dep.artifact("libpng");

    lib.root_module.linkLibrary(png_lib);

    lib.addIncludePath(lib_dep.path("include"));
    lib.addIncludePath(lib_dep.path("src"));
    lib.installHeader(lib_dep.path("include/SDL3_image/SDL_image.h"), "SDL3_image/SDL_image.h");
    lib.root_module.addCMacro("LOAD_BMP", "1");
    lib.root_module.addCMacro("LOAD_PNG", "1");
    lib.root_module.addCSourceFiles(.{
        .root = lib_dep.path(""), 
        .files = &.{
            "src/IMG.c",
            "src/IMG_bmp.c",
            "src/IMG_gif.c",
            "src/IMG_tga.c",
            "src/IMG_avif.c",
            "src/IMG_jpg.c",
            "src/IMG_lbm.c",
            "src/IMG_jxl.c",
            "src/IMG_pcx.c",
            "src/IMG_png.c",
            "src/IMG_pnm.c",
            "src/IMG_svg.c",
            "src/IMG_tif.c",
            "src/IMG_xcf.c",
            "src/IMG_xpm.c",
            "src/IMG_xv.c",
            "src/IMG_webp.c",
            "src/IMG_qoi.c",
            
        }});
    b.installArtifact(lib);
}
