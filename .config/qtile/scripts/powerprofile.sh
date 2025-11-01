#!/usr/bin/env sh

profiles=("performance" "balanced" "power-saver")

# Get the current active profile
current=$(powerprofilesctl get)

# Build rofi menu
chosen=$(printf "%s\n" "${profiles[@]}" | \
    rofi -dmenu -p "Power Profile" -theme-str 'window {width: 20%;}')

# Exit if nothing selected
[ -z "$chosen" ] && exit 0

# Apply the selected profile
if powerprofilesctl set "$chosen"; then
    notify-send "⚡ Power Profile Changed" \
        "Current profile: <b>$chosen</b>" \
        -i power-profile \
        -h string:x-canonical-private-synchronous:powerprofile
else
    notify-send "❌ Failed to set power profile" \
        "Could not set: $chosen" \
        -u critical
fi
