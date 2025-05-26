#!/bin/bash

###change brightness on external screen that supports i2c. Created while trying to learn bash script with the helpo of chatGPT
###two wrapper script also had to be created
# Get monitor brightness values
get_values() {
    output=$(ddcutil getvcp 10 2>/dev/null)
    current=$(echo "$output" | grep -oP 'current value =\s+\K[0-9]+')
    max=$(echo "$output" | grep -oP 'max value =\s+\K[0-9]+')
}

# Set brightness by percentage
if [ -n "$1" ]; then
    get_values
    new_percentage=$1

    # Clamp the percentage to a valid range
    [ "$new_percentage" -lt 0 ] && new_percentage=0
    [ "$new_percentage" -gt 100 ] && new_percentage=100

    # Convert percentage to raw value
    new_value=$(( new_percentage * max / 100 ))
    ddcutil setvcp 10 "$new_value" >/dev/null 2>&1

    # Give the monitor a short moment to apply
    sleep 0.3
fi

# Now fetch and display the current brightness
get_values
percentage=$(( current * 100 / max ))
echo "${percentage}%"
