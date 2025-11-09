#!/bin/bash

# Path to PipeWire daemon log (you may need to adjust this path)
LOG_PATH="/var/log/pipewire-alsa.log"

function notify_volume_change() {
  local previous_volume=$(tail -n +2 "$1" | awk '{print $NF}')
  
  # Get the current volume
  new_volume=$(awk '/\[\[ master \]\]/ { print int($8 / 100 * 65535) }' "$LOG_PATH")
  
  if [[ $new_volume != $previous_volume ]]; then
    notify-send "Volume changed" "[Master] Volume: ${new_volume}"
    
    # Update previous volume to current for the next check (could be optimized further)
    echo $new_volume > /tmp/volume.current.txt
  fi
}

# Monitor PipeWire daemon log file and wait until it exists before starting monitoring.
while true; do
  if [[ -f "$LOG_PATH" ]]; then
      notify_volume_change "$LOG_PATH"
      sleep 5 # Adjust this interval as needed to reduce resource usage
  else
    echo "PipeWire daemon not running. Waiting..."
    while ! pidof pipewire >/dev/null ; do
        sleep 2
    done
    
    if [[ -f "$LOG_PATH" ]]; then
      notify_volume_change "$LOG_PATH"
    fi

    # Restart the monitoring loop after PipeWire is detected.
    break  
    echo "PipeWire log file not found. Waiting..."
    while ! pidof pipewire >/dev/null ; do
        sleep 2
    done
    
    if [[ -f "$LOG_PATH" ]]; then
      notify_volume_change "$LOG_PATH"
    fi

    # Restart the monitoring loop after PipeWire is detected.
    break  
  fi
done
