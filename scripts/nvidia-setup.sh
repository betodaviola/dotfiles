#!/bin/bash
# Setup for Reverse PRIME, ensuring iGPU renders, dGPU passes-through
xrandr --setprovideroutputsource modesetting Intel
xrandr --output HDMI-1-0 --right-of eDP-1 --auto
xrandr --output eDP-1 --primary
