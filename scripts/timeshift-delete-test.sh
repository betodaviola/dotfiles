#!/bin/bash

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
