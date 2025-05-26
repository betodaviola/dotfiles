#!/bin/bash

# Output file
OUTPUT="/mnt/storage/Stuff/beto_bkp/GitProjects/dotfiles/installed-packages.txt"

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
