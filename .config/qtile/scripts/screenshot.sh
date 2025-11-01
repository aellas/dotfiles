#!/usr/bin/env sh

options="󰹑  Fullscreen\n󰨵  Region"
choice=$(echo -e "$options" | rofi -dmenu -theme-str 'window { width: 20%; }' -no-fixed-num-lines -p "Screenshot")

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
filename="screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
filepath="$DIR/$filename"

case "$choice" in
    "󰹑  Fullscreen")
        grim "$filepath" && wl-copy < "$filepath"
        notify-send "Screenshot saved" "$filepath"
        ;;

    "󰨵  Region")
        geom=$(slurp)
        if [ -z "$geom" ]; then
          notify-send "Screenshot cancelled"
          exit 1
        fi
        grim -g "$geom" "$filepath" && wl-copy < "$filepath"
        notify-send "Screenshot (selection) saved" "$filepath"
        ;;

    *)
        exit 1
        ;;
esac
