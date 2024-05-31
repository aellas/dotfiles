#!/bin/bash

# Read the values from the respective files
calories=$(cat /tmp/waybar_calories.txt 2>/dev/null)
sleep=$(cat /tmp/waybar_sleep.txt 2>/dev/null)
calories_burnt=$(cat /tmp/waybar_calories_burnt.txt 2>/dev/null)
water_intake=$(cat /tmp/waybar_water_intake.txt 2>/dev/null)

# Check if any value is not a number and set it to 0
if ! [[ "$calories" =~ ^[0-9]+$ ]]; then
  calories=0
fi

if ! [[ "$sleep" =~ ^[0-9]+$ ]]; then
  sleep=0
fi

if ! [[ "$calories_burnt" =~ ^[0-9]+$ ]]; then
  calories_burnt=0
fi

if ! [[ "$water_intake" =~ ^[0-9]+$ ]]; then
  water_intake=0
fi

# Set the threshold values for each metric
calories_threshold=1900
sleep_threshold=24  # Hours
calories_burnt_threshold=5000
water_intake_threshold=100  # Glasses

# Determine the color based on each value
if (( calories >= calories_threshold )) && (( sleep >= sleep_threshold )) && (( calories_burnt >= calories_burnt_threshold )) && (( water_intake >= water_intake_threshold )); then
  color="#00FF00"  # Green
else
  color="#FF0000"  # Red
fi

# Output the JSON for Waybar
echo "{\"text\":\"   •    󱤖  $calories kcal      $calories_burnt kcal    󰤄  $sleep hours    󰆪  $water_intake litres \",\"tooltip\":\"Calories: $calories kcal\nSleep: $sleep hours\nCalories Burnt: $calories_burnt kcal\nWater Intake: $water_intake cups\",\"class\":\"custom\",\"background\":\"$color\"}"
