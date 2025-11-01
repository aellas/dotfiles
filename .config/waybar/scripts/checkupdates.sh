#!/usr/bin/env bash

# Check for available updates
updates=$(dnf check-update --refresh 2>/dev/null | grep -c '^[[:alnum:]]')

if [ "$updates" -gt 0 ]; then
  # Updates available
  echo "{\"text\": \"$updates\", \"class\": \"has-updates\", \"icon\": \"has-updates\", \"tooltip\": \"$updates updates available\"}"
else
  # No updates → show 0 and different icon
  echo "{\"text\": \"0\", \"class\": \"updated\", \"icon\": \"updated\", \"tooltip\": \"System up to date\"}"
fi
