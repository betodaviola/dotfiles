#!/bin/bash

# Detects if any HDMI screen is plugged when i3 loads. If so, I am probably home, so load screens appropriately

# Get external monitor name (anything except eDP-1)
EXT_MON=$(xrandr | grep ' connected' | grep -v eDP | awk '{ print $1 }' | head -n 1)
INT_MON=$(xrandr | grep ' connected' | grep eDP | awk '{ print $1 }')

open polybar on internal monitor
killall polybar
polybar polybar1 -c ~/.config/polybar/config1.ini 2>&1 | tee -a /tmp/polybar.log & disown

if [ -n "$EXT_MON" ]; then
    xrandr --output "$EXT_MON" --auto --left-of "$INT_MON" --output "$INT_MON" --auto
    feh --bg-fill /home/beto/Pictures/wallpapers/commuTux.jpg
    polybar polybar1 -c ~/.config/polybar/config2.ini 2>&1 | tee -a /tmp/polybar.log & disown
fi
