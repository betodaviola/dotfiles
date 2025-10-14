#!/bin/bash

BOLD='\033[1m'
UND='\033[4m' #underscore
RESET='\033[0m'

# List thrash bin contents and give the opportunity to clean it up:
local_thrash_files=$(ls -Shas /home/beto/.local/share/Trash/files)
local_thrash_info=$(ls -Shas /home/beto/.local/share/Trash/info)
storage_thrash_files=$(ls -Shas /mnt/storage/.Trash-1000/files)
storage_thrash_info=$(ls -Shas /mnt/storage/.Trash-1000/info)

echo -e "${BOLD}Would you like to delete the following files from your thrash bin?${RESET}"
echo -e "${UND}Local thrash files:${RESET}"
echo -e "$local_thrash_files"
echo -e "${UND}Local info files:${RESET}"
echo -e "$local_info_files"
echo -e "${UND}Storage thrash files:${RESET}"
echo -e "$storage_thrash_files"
echo -e "${UND}Storage info files:${RESET}"
echo -e "$storage_info_files"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                rm -rf /home/beto/.local/share/Trash/files/*
                rm -rf /home/beto/.local/share/Trash/info/*
                rm -rf /mnt/storage/.Trash-1000/files/*
                rm -rf /mnt/storage/.Trash-1000/info/*
                break;;
            No ) 
                break;;
        esac
    done

#Clean the package cache keeping only the last version of a pachage
echo "cleaning pacman cache"
sudo paccache -rk1

#Remove orphaned packages
echo "removing pacman orphaned packages"
sudo pacman -Rns $(pacman -Qdtq)

#Clear journal logs leaving only the past 2 days
echo "cleaning journals"
sudo journalctl --rotate --vacuum-time=2weeks

#Remove unused yay build files:
echo "cleaning AUR cache"
yay -Sc --aur

#Clean up user cache
echo "cleaning user cache"
rm -rf ~/.cache/*





#!/bin/bash

# A script to empty all user trash cans on the system

echo "🗑️  Emptying home directory trash..."
# Safely remove the contents of the files and info directories
rm -rf ~/.local/share/Trash/files/*
rm -rf ~/.local/share/Trash/info/*

echo "🗑️  Searching for and emptying trash on other drives..."
# Find all .Trash-1000 directories in common mount locations and empty them
# The '2>/dev/null' hides any "permission denied" errors for folders you can't access
for trash_dir in $(find /mnt /run/media -type d -name ".Trash-1000" 2>/dev/null); do
  echo "   - Emptying $trash_dir"
  rm -rf "$trash_dir/files/*"
  rm -rf "$trash_dir/info/*"
done

echo "✅ Cleanup complete!"