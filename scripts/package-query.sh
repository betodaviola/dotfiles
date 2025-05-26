#!/bin/bash

# Output file
OUTPUT="/mnt/storage/Stuff/beto_bkp/GitProjects/dotfiles/installed-packages.txt"

# Start fresh
> "$OUTPUT"

# Add fastfetch output
echo "### System Overview (fastfetch) ###" >> "$OUTPUT"
fastfetch --no-color >> "$OUTPUT" 2>/dev/null || echo "fastfetch not installed or failed to run." >> "$OUTPUT"
echo -e "\n" >> "$OUTPUT"

# List official (pacman) packages with description
echo "### Explicitly Installed Official Packages (pacman) ###" >> "$OUTPUT"
for pkg in $(pacman -Qqe | grep -vxFf <(yay -Qm | awk '{print $1}') | sort); do
    desc=$(pacman -Si "$pkg" 2>/dev/null | grep -m1 "^ *Description" | cut -d ':' -f2- | sed 's/^ *//')
    printf "%s - %s\n" "$pkg" "${desc:-No description found}" >> "$OUTPUT"
done
echo -e "\n" >> "$OUTPUT"

# List AUR packages with description
echo "### AUR Packages (installed via yay) ###" >> "$OUTPUT"
for pkg in $(yay -Qm | awk '{print $1}' | sort); do
    desc=$(yay -Qi "$pkg" 2>/dev/null | grep -m1 "^Description" | cut -d ':' -f2- | sed 's/^ *//')
    printf "%s - %s\n" "$pkg" "${desc:-No description found}" >> "$OUTPUT"
done
echo -e "\n" >> "$OUTPUT"

echo "System package list saved to $OUTPUT"
