# zig-xplat-sdl-example
An example of an application drawing to the canvas with SDL2. The majority of the code is written in Zig. Currently runs on the web through Emscripten, and natively on iOS.

The Zig code has been ported from [this C example](https://www.jamesfmackenzie.com/2019/12/01/webassembly-graphics-with-sdl/).

## Usage
### Web
The code is set up to support the web build by default.

Assuming Emscripten is already installed and on your PATH, just run `./build-web.sh` on a UNIX machine to build. Windows users can create their own scripts, or just type in the commands from that script individually.

Once the build is done, open the `zig-out/web` directory and serve the files from a web server to view the app.

### iOS
There's a pre-built Xcode project in `ios/ios-template` used to run on iOS. An SDL2 framework and pre-built library based on this code are already provided, so the app should run fine. But in case it doesn't, you need to compile your own by modifying the Zig code.

Those changes are:

1. Change `build.zig` to invoke `buildIos` instead of `buildWeb`.
2. In `main.zig`, comment out the `emscripten.h` line in `@cImport`.
3. Comment out the `emscripten_set_main_loop` line at the bottom of the file and uncomment `nativeGameLoop()`.
4. Uncomment lines 71-75 to get the correct display size on iOS.
5. Change the path on line 94 to use `"planet.png"` instead of `"assets/planet.png"`.

After this is done, run `zig build` and you'll get a static library in `zig-out/lib` called `libsdl-test.a`.

Open the provided Xcode project and replace the existing library file in `lib` with your new one. Do this operation from within Xcode (ie. through drag and drop from Finder) so that Xcode automatically sets up library paths.

If you get SDL2 errors, you likely need a new version of the SDL2 framework built for iOS. The SDL repository has a README that you can use for this.
