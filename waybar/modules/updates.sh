#!/bin/bash

# Function to check for updates and update the Waybar display
update_waybar() {
    updates_count=$(pacman -Qu | wc -l)
    echo "{\"text\":\" $updates_count    \"  ,\"tooltip\":\"$updates_count updates available\",\"class\":\"$updates_count\"}"
}

# Update Waybar display initially
update_waybar

# Continuously update Waybar display every 300 seconds (5 minutes)
while true; do
    sleep 300
    update_waybar
done
