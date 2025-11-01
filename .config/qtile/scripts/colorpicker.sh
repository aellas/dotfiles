#!/usr/bin/env sh

grim -g "$(slurp -p)" -t ppm - | magick - -format '%[pixel:p{0,0}]' txt:- | grep -oE '#[0-9A-Fa-f]{6}' | wl-copy
