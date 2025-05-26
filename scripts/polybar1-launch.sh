#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config1.ini
polybar polybar1 -c ~/.config/polybar/config1.ini 2>&1 | tee -a /tmp/polybar.log & disown
polybar polybar1 -c ~/.config/polybar/config2.ini 2>&1 | tee -a /tmp/polybar.log & disown
#polybar dummybar -c ~/.config/polybar/config1.ini 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar1 launched..."
