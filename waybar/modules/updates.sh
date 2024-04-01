#!/bin/sh

# Run the command to get the number of updates available
updates_count=$(pacman -Qu | wc -l)
# Format the result in a JSON-like format
result="{\"updates_count\": $updates_count}"

# Print the result
echo "            $updates_count    "
