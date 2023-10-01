const std = @import("std");

const sdl = @cImport({
    @cInclude("stdlib.h");
    @cInclude("emscripten.h");
    @cInclude("SDL/SDL.h");
    @cInclude("SDL/SDL_image.h");
});

var window: ?*sdl.SDL_Window = null;
var renderer: ?*sdl.SDL_Renderer = null;
var texture: ?*sdl.SDL_Texture = null;
var event: sdl.SDL_Event = undefined;

var windowWidth: i32 = 640;
var windowHeight: i32 = 480;

const snekWidth = 294;
const snekHeight = 289;

var snekX: i32 = 0;
var snekY: i32 = 0;

var running = true;

fn webGameLoop() callconv(.C) void {
    drawLoop();
}

fn nativeGameLoop() void {
    while (running) {
        while (sdl.SDL_PollEvent(&event) != 0) {
            if (event.type == sdl.SDL_QUIT) {
                running = false;
            }
        }

        drawLoop();
    }
}

fn drawLoop() void {
    _ = sdl.SDL_RenderClear(renderer);

    const destination = sdl.SDL_Rect{
        .x = snekX,
        .y = snekY,
        .w = snekWidth,
        .h = snekHeight,
    };

    _ = sdl.SDL_RenderCopy(renderer, texture, 0, &destination);
    sdl.SDL_RenderPresent(renderer);
}

pub export fn appInit() void {
    if (sdl.SDL_Init(sdl.SDL_INIT_VIDEO) < 0) {
        std.debug.print("{s}\n", .{sdl.SDL_GetError()});
        return;
    }
    defer sdl.SDL_Quit();

    const imgFlags = sdl.IMG_INIT_PNG;
    if ((sdl.IMG_Init(imgFlags) & imgFlags) != 2) {
        std.debug.print("Image init error: {s}\n", .{sdl.IMG_GetError()});
        return;
    }
    defer sdl.IMG_Quit();

    // this should be disabled on anything non-mobile
    // var displayMode: sdl.SDL_DisplayMode = undefined;
    // if (sdl.SDL_GetCurrentDisplayMode(0, &displayMode) == 0) {
    //     windowWidth = displayMode.w;
    //     windowHeight = displayMode.h;
    // }
    snekX = @divTrunc(windowWidth, 2) - snekWidth / 2;
    snekY = @divTrunc(windowHeight, 2) - snekHeight / 2;

    window = sdl.SDL_CreateWindow("SDL2 Test", 0, 0, windowWidth, windowHeight, 0);
    if (window == null) {
        std.debug.print("Window error: {s}\n", .{sdl.SDL_GetError()});
        return;
    }
    defer sdl.SDL_DestroyWindow(window);

    renderer = sdl.SDL_CreateRenderer(window, -1, sdl.SDL_RENDERER_ACCELERATED);
    if (renderer == null) {
        std.debug.print("Renderer error: {s}", .{sdl.SDL_GetError()});
        return;
    }
    _ = sdl.SDL_SetRenderDrawColor(renderer, 255, 0, 255, 255);
    defer sdl.SDL_DestroyRenderer(renderer);

    var surface: ?*sdl.SDL_Surface = sdl.IMG_Load("assets/planet.png");
    if (surface == null) {
        std.debug.print("Image load error: {s}\n", .{sdl.SDL_GetError()});
        return;
    }

    texture = sdl.SDL_CreateTextureFromSurface(renderer, surface);
    if (texture == null) {
        std.debug.print("Texture creation error: {s}\n", .{sdl.SDL_GetError()});
        return;
    }
    sdl.SDL_FreeSurface(surface);
    defer sdl.SDL_DestroyTexture(texture);

    // nativeGameLoop();
    sdl.emscripten_set_main_loop(webGameLoop, 0, 1);
}
