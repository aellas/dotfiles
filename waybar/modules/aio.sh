#!/bin/bash

toggle_mode() {
    current_mode=$(liquidctl --match corsair status)
    if [[ $current_mode == *"quiet"* ]]; then
        new_mode="balanced"
    elif [[ $current_mode == *"balanced"* ]]; then
        new_mode="extreme"
    else
        new_mode="quiet"
    fi
    echo "$new_mode"
}

set_mode() {
    mode=$1
    if [[ $mode == "quiet" ]]; then
        liquidctl --match corsair initialize --pump-mode balanced
        liquidctl --match corsair set fan speed 32 20 33 30 34 38 36 50 38 72 40 85 42 100
    elif [[ $mode == "balanced" ]]; then
        liquidctl --match corsair initialize --pump-mode balanced
        liquidctl --match corsair set fan speed 29 20 30 30 31 47 32 55 33 69 34 85 35 100
    elif [[ $mode == "extreme" ]]; then
        liquidctl --match corsair initialize --pump-mode extreme
        liquidctl --match corsair set fan speed 26 35 27 40 28 50 29 65 30 76 32 90 32 100
    else
        echo "Invalid mode."
    fi
}

if [[ "$1" == "toggle" ]]; then
    new_mode=$(toggle_mode)
    set_mode "$new_mode"
    echo "Mode switched to $new_mode"
else
    current_mode=$(liquidctl --match corsair status)
    echo "$current_mode"
fi
