#!/bin/bash

status=$(playerctl -p spotify status)
icon="  "

if [ "$status" == "Playing" ]; then
  artist=$(playerctl -p spotify metadata --format '{{ artist }}')
  title=$(playerctl -p spotify metadata --format '{{ title }}')

  # Replace & with &amp;
  artist_escaped=$(echo "$artist" | sed 's/&/\&amp;/g')
  title_escaped=$(echo "$title" | sed 's/&/\&amp;/g')

  metadata="$artist_escaped - $title_escaped"

  if [ ${#metadata} -gt 100 ]; then
    metadata=$(echo "   $metadata" | cut -c1-100)"..."
  fi

  text="$icon$metadata"
elif [ "$status" == "Paused" ]; then
  text="   $icon the classic symptoms of a broken spirit"
else
  text="   $icon the classic symptoms of a broken spirit"
fi

echo "$text"
