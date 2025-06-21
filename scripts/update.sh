#!/bin/bash

###Delete all timeshift backups except from the latest day when it was last created.

# Path to Timeshift snapshots
SNAPSHOT_DIR="/mnt/storage/timeshift/snapshots"

# Get the latest snapshot date (YYYY-MM-DD)
latest_date=$(ls "$SNAPSHOT_DIR" | awk -F_ '{print $1}' | sort -u | tail -n 1)

echo "Keeping snapshots from latest date: $latest_date"

# Get all snapshot folder names
all_snapshots=$(ls "$SNAPSHOT_DIR")

# Loop through them and delete if not from the latest date
for snapshot in $all_snapshots; do
    snap_date="${snapshot%%_*}"  # extract the date part before the "_"
    if [[ "$snap_date" != "$latest_date" ]]; then
        echo "Deleting snapshot: $snapshot"
        sudo timeshift --delete --snapshot "$snapshot"
    fi
done

### creates a new snapshots. this ensures always the last 2 (days of) snapshots will be kept
sudo timeshift --create

###backs up important dotfiles to my git folder
#create array with the relevant paths (makes for easier editing of this script):
declare -a dots=(".zshrc" ".bashrc" ".rofi_todos" ".fehbg" ".xinitrc" ".gitconfig" ".config/.bash_aliases" ".config/i3" ".config/conky" ".config/picom" ".config/pipewire" ".config/polybar" ".config/rofi" ".config/scripts" ".config/wireplumber")

echo "Backing up important dotfiles"

#iterate through the array, copying every directory
for i in "${dots[@]}"
do
    sudo rsync -aAuHXvis --numeric-ids --info=progress2 /home/beto/$i /mnt/storage/Stuff/tux_bkp/GitProjects/dotfiles
done

echo "Creating installed packages list"
# Output file
OUTPUT="/mnt/storage/Stuff/tux_bkp/GitProjects/dotfiles/installed-packages.txt"

# Start fresh
> "$OUTPUT"

cat << "EOF" >> "$OUTPUT"
                 -`
                .o+`
               `ooo/
              `+oooo:
             `+oooooo:
             -+oooooo+:
           `/:-:++oooo+:
          `/++++/+++++++:
         `/++++++++++++++:
        `/+++ooooooooooooo/`
       ./ooosssso++osssssso+`
      .oossssso-````/ossssss+`
     -osssssso.      :ssssssso.
    :osssssss/        osssso+++.
   /ossssssss/        +ssssooo/-
 `/ossssso+/:-        -:/+osssso+-
`+sso+:-`                 `.-/+oso:
`++:.                           `-/+/
`.`                                 `/
EOF

### System Info Section
echo "### System Overview ###" >> "$OUTPUT"
echo "OS: $(source /etc/os-release && echo "$PRETTY_NAME")" >> "$OUTPUT"
echo "Kernel: $(uname -r)" >> "$OUTPUT"
echo "Uptime: $(uptime -p)" >> "$OUTPUT"
echo "Shell: $SHELL" >> "$OUTPUT"
echo "Packages (pacman): $(pacman -Qq | wc -l)" >> "$OUTPUT"
echo "WM/DE: ${XDG_CURRENT_DESKTOP:-$DESKTOP_SESSION}" >> "$OUTPUT"
echo "Terminal: $TERM" >> "$OUTPUT"

# CPU and GPU info
echo "CPU: $(lscpu | grep 'Model name' | sed 's/Model name:[ \t]*//')" >> "$OUTPUT"

# GPU detection (Intel + NVIDIA)
echo -n "GPU(s): " >> "$OUTPUT"
lspci | grep -E "VGA|3D" | awk -F': ' '{print $2}' | paste -sd ' | ' >> "$OUTPUT"

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

#updates dotfile repo on github
cd /mnt/storage/Stuff/tux_bkp/GitProjects/dotfiles
git add .
git commit -m "Automatic backup of dotfiles done with manual update script. See .config/scripts/update.sh for more details"
git push origin main

###updates and confirm that all was done
yay -Syu
echo "Update completed. Backup saved to /mnt/storage/timeshift/snapshots"
