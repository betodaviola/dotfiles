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
declare -a dots=(".zshrc" ".bashrc" ".rofitodos" ".fehbg" ".xinitrc" ".gitconfig".config/.bash_aliases".config/i3" ".config/conky" ".config/picom" ".config/pipewire" ".config/polybar" ".config/rofi" ".config/scripts" ".config/wireplumber")

echo "Backing up important dotfiles"

#iterate through the array, copying every directory
for i in "${dots[@]}"
do
    sudo rsync -aAuHXvis --numeric-ids --info=progress2 /home/beto/$i /mnt/storage/Stuff/beto_bkp/GitProjects/dotfiles
done









###updates and confirm that all was done
yay -Syu
echo "Update completed. Backup saved to /mnt/storage/timeshift/snapshots"
