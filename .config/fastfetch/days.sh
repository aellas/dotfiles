#!/usr/bin/env sh


FIRST_USE_FILE="$HOME/.distro_first_use"

if [ ! -f "$FIRST_USE_FILE" ]; then
    date '+%Y-%m-%d' > "$FIRST_USE_FILE"
fi

FIRST_USE_DATE=$(cat "$FIRST_USE_FILE")

TODAY=$(date +%s)

FIRST_USE_SEC=$(date -d "$FIRST_USE_DATE" +%s)

DAYS=$(( (TODAY - FIRST_USE_SEC) / 86400 ))

echo "$DAYS"
