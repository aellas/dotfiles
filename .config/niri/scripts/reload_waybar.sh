#!/usr/bin/env sh

# Kill and reload Waybar
pkill waybar
waybar &
# Kill and restart swaync
