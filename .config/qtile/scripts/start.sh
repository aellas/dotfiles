#!/usr/bin/env sh

# ~/bin/start-qtile-wayland — Run Qtile Wayland from TTY

# Run Qtile Wayland
exec dbus-run-session qtile start -b wayland
