#!/bin/sh
source emsdk_env.sh
mkdir zig-out/web

zig build && emcc main.c \
    -Lzig-out/lib \
    -lsdl-test \
    -o zig-out/web/index.html \
    -s USE_SDL=2 \
    -s USE_SDL_IMAGE=2 \
    --use-preload-plugins \
    -s SDL2_IMAGE_FORMATS='["png"]' \
    --preload-file assets/planet.png
