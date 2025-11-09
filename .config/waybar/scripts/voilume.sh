#!/usr/bin/env sh

LOG_PATH="/var/log/pulse/daemon.log"

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

# Monitor PulseAudio daemon log file and wait until it exists before starting monitoring.
while true; do
  if [[ -f "$LOG_PATH" ]]; then
      notify_volume_change "$LOG_PATH"
      sleep 5 # Adjust this interval as needed to reduce resource usage
  else
    echo "Pulse Audio daemon not running. Waiting..."
    while ! pidof pulseaudio >/dev/null ; do
        sleep 2
    done
    
    if [[ -f "$LOG_PATH" ]]; then
      notify_volume_change "$LOG_PATH"
    fi

    # Restart the monitoring loop after PulseAudio is detected.
    break  
  else
    echo "Pulse Audio log file not found. Waiting..."
    while ! pidof pulseaudio >/dev/null ; do
        sleep 2
    done
    
    if [[ -f "$LOG_PATH" ]]; then
      notify_volume_change "$LOG_PATH"
    fi

    # Restart the monitoring loop after PulseAudio is detected.
    break  
  fi
done
