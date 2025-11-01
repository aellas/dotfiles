#!/usr/bin/env sh

way-displays &
waypaper --restore &
wl-copy &
wl-paste --type text --watch cliphist store & # Saves text
wl-paste --type image --watch cliphist store & # Saves images
emacs --daemon &
mako &
/usr/libexec/polkit-mate-authentication-agent-1 &
