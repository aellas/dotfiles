#!/bin/bash

# Prompt the user for input
read -p "How many calories did you eat today? " calories
read -p "How many hours did you sleep today? " sleep
read -p "How many calories did you burn today? " calories_burnt
read -p "How many cups of water did you drink today? " water_intake

# Save the information to files in /tmp
echo "$calories" > /tmp/waybar_calories.txt
echo "$sleep" > /tmp/waybar_sleep.txt
echo "$calories_burnt" > /tmp/waybar_calories_burnt.txt
echo "$water_intake" > /tmp/waybar_water_intake.txt
