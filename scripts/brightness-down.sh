#!/bin/bash
file="$HOME/.cache/target-brightness"

# Get current or default to real brightness
val=$(cat "$file" 2>/dev/null || ~/.config/scripts/i2c-brightness.sh | tr -d '%')
val=$(( val - 5 ))
[ "$val" -lt 0 ] && val=0
echo "$val" > "$file"
