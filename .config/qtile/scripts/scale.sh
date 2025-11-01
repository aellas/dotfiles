#!/usr/bin/env sh

echo "Checking display status..."
DISPLAY_STATUS=$(wlr-randr | grep -A2 '^eDP')

if echo "$DISPLAY_STATUS" | grep -q "Enabled"; then
    echo "Internal display is enabled. Setting text-scaling-factor to 1.15"
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.15
else
    echo "Internal display is not enabled. Setting text-scaling-factor to 1.00"
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.00
fi
