#!/usr/bin/env sh

# Force Bolt to use Wayland
export _JAVA_AWT_WM_NONREPARENTING=1

flatpak run com.adamcake.Bolt --enable-features=UseOzonePlatform --ozone-platform=wayland
