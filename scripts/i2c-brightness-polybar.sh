#!/bin/bash
file="$HOME/.cache/target-brightness"
if [ -f "$file" ]; then
    cat "$file"
else
    ~/.config/scripts/i2c-brightness.sh
fi

