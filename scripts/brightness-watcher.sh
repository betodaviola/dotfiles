#!/bin/bash

file="$HOME/.cache/target-brightness"
last_value=""

while true; do
    if [ -f "$file" ]; then
        value=$(cat "$file")
        if [ "$value" != "$last_value" ]; then
            last_change=$(date +%s%3N)  # ms timestamp
            last_value="$value"
        fi

        now=$(date +%s%3N)
        elapsed=$(( now - last_change ))

        if [ "$elapsed" -gt 500 ]; then
            ~/.config/scripts/i2c-brightness.sh "$value"
            rm "$file"
            last_value=""
        fi
    fi
    sleep 0.1
done
