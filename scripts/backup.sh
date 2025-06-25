#!/bin/bash

### Backup system to betoRed external SSD

LABEL="betoRed"
MOUNTPOINT="/mnt/betoRed-bkp"
NOW=$(date +"%Y.%m.%d_%H.%M.%S")
COPIES=2  # Number of total copies to keep
SRC_DIR="/mnt/storage/Stuff/tux_bkp"

# Check if already mounted
if mountpoint -q "$MOUNTPOINT"; then
    echo "Already mounted."
else
    # Find the device by label
    DEV=$(lsblk -nr -o NAME,LABEL | grep "$LABEL" | awk '{print "/dev/" $1}' | head -n 1)

    if [ -z "$DEV" ]; then
        echo "Device with label $LABEL not found. Plug it in?"
        exit 1
    fi

    echo "Mounting $DEV to $MOUNTPOINT..."
    sudo mount "$DEV" "$MOUNTPOINT"
fi

# Perform rsync backup
echo "Backing up storage."
sudo rsync -aAuHXvis --numeric-ids --info=progress2 /mnt/storage/Stuff/tux_bkp/ /mnt/betoRed-bkp/storage-beto-bkp/beto-bkp[${NOW}]
echo "Backing up home directory."
sudo rsync -aAuHXvis --numeric-ids --info=progress2 /home/beto/ /mnt/betoRed-bkp/beto-home-bkp/beto-home[${NOW}]
echo "Backing up timeshift snapshots."
sudo rsync -aAuHXvis --numeric-ids --info=progress2 /mnt/storage/timeshift/snapshots/ /mnt/betoRed-bkp/timeshift-system-bkp/timeshift-snapshots[${NOW}]

# Keep only the $COPIES most recent backups
echo "Pruning old backups..."

echo "Pruning old storage backups..."
while read -r dir; do
    echo "Deleting old backup: $dir"
    sudo rm -rfv -- "/mnt/betoRed-bkp/storage-beto-bkp/$dir"
done < <(ls -1t /mnt/betoRed-bkp/storage-beto-bkp | tail -n +$((COPIES + 1)))

echo "Pruning old system backups..."
while read -r dir; do
    echo "Deleting old backup: $dir"
    sudo rm -rfv -- "/mnt/betoRed-bkp/timeshift-system-bkp/$dir"
done < <(ls -1t /mnt/betoRed-bkp/timeshift-system-bkp | tail -n +$((COPIES + 1)))

echo "Pruning old home backups..."
while read -r dir; do
    echo "Deleting old backup: $dir"
    sudo rm -rfv -- "/mnt/betoRed-bkp/beto-home-bkp/$dir"
done < <(ls -1t /mnt/betoRed-bkp/beto-home-bkp | tail -n +$((COPIES + 1)))


if sudo umount "$MOUNTPOINT"; then
    echo "Backup completed."
else
    echo "Warning: Failed to unmount $MOUNTPOINT. Is something still using it?"
fi
