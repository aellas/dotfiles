#!/usr/bin/env sh

options=" Shutdown\n Reboot\n󰒲 Suspend\n Lock\n󰿅 Logout"

chosen=$(echo -e "$options" | rofi -dmenu -theme-str 'window { width: 20%; }' -no-fixed-num-lines -i -p "Power Menu")

case "$chosen" in
    " Shutdown")
        systemctl poweroff
        ;;
    " Reboot")
        systemctl reboot
        ;;
    "󰒲 Suspend")
        systemctl suspend
        ;;
    " Lock")
        hyprlock 
        ;;
    "󰿅 Logout")
        niri msg action quit --skip-confirmation
        ;;
esac
