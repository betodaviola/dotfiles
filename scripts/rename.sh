#!/usr/bin/env bash

# Prompt for the directory
read -rp "Enter the path to the directory: " target_dir

# Check if directory exists
if [[ ! -d "$target_dir" ]]; then
  echo "Error: Directory does not exist."
  exit 1
fi

# Change into the directory
cd "$target_dir" || exit

# Loop through files
for f in *; do
  if [[ "$f" == *:*-* ]]; then
    newname=$(echo "$f" | sed 's/:[^-]*//')
    if [[ "$f" != "$newname" ]]; then
      echo "Renaming: $f -> $newname"
      mv -- "$f" "$newname"
    fi
  fi
done

echo "Done."
