#!/bin/bash

# Default values
POSITION=""
ROTATE="normal"

# Laptop and external monitor names
INTERNAL=$(xrandr | grep ' connected' | grep eDP | awk '{ print $1 }')
EXTERNAL=$(xrandr | grep ' connected' | grep -v eDP | awk '{ print $1 }' | head -n 1)

# Help message
show_help() {
  echo "Usage: screen-connect -[l|r|t|b] [--rotate normal|left|right|inverted]"
  echo
  echo "  -l        Place external screen to the left of laptop"
  echo "  -r        Place external screen to the right of laptop"
  echo "  -t        Place external screen above laptop"
  echo "  -b        Place external screen below laptop"
  echo
  echo "  --rotate  Rotate external screen (default: normal)"
  echo "            Options: normal, left, right, inverted"
  echo
  echo "  --help    Show this help message"
}

# No arguments
if [ "$#" -eq 0 ]; then
  echo "Error: No arguments provided."
  echo "Use --help to see usage instructions."
  exit 1
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -l|-r|-t|-b)
      POSITION="$1"
      shift
      ;;
    --rotate)
      ROTATE="$2"
      shift 2
      ;;
    --help)
      show_help
      exit 0
      ;;
    *)
      echo "Error: Unknown option '$1'"
      echo "Use --help to see usage instructions."
      exit 1
      ;;
  esac
done

# Validate position
if [ -z "$POSITION" ]; then
  echo "Error: You must specify one of -l, -r, -t, -b"
  echo "Use --help to see usage instructions."
  exit 1
fi

# Map -l to left-of, etc.
case "$POSITION" in
  -l) POS_OPT="--left-of" ;;
  -r) POS_OPT="--right-of" ;;
  -t) POS_OPT="--above" ;;
  -b) POS_OPT="--below" ;;
esac

# Apply with xrandr
xrandr --output "$EXTERNAL" --auto "$POS_OPT" "$INTERNAL" --rotate "$ROTATE"
feh --bg-fill /home/beto/Pictures/wallpapers/sfwtux.png #set wallpaper
killall polybar
while pgrep -x polybar >/dev/null; do sleep 0.1; done
polybar polybar1 -c ~/.config/polybar/config1.ini 2>&1 | tee -a /tmp/polybar.log & disown
polybar polybar1 -c ~/.config/polybar/config2.ini 2>&1 | tee -a /tmp/polybar.log & disown
