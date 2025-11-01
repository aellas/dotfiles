#!/usr/bin/env sh

cliphist list | rofi -dmenu -theme-str 'window { width: 50%; }' -no-fixed-num-lines -p "Clipboard"  | cliphist decode | wl-copy
