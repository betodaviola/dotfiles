alias cpv='rsync -rh --info=progress2'
alias config='cd && nano .config/i3/config'
alias wconfig='cd && nano .config/hypr/hyprland.conf'
alias pro-audio='sudo cpupower frequency-set -g performance && pw-metadata --name settings 0 clock.rate 48000 && pw-metadata --name settings 0 clock.force-quantum 256'
alias i3logs='DISPLAY=:0 i3-dump-log'
alias pro-gaming='xrandr --output HDMI-1-0 --primary'
alias git-projects='cd /mnt/storage/Stuff/tux_bkp/GitProjetcs'
alias stable-audio='source ~/stable-audio-tools/.venv/bin/activate'



### script aliases
alias update='.config/scripts/update.sh'
alias backup='.config/scripts/backup.sh'
alias cleanup='.config/scripts/cleanup.sh'
alias wiki='.config/scripts/archwiki-offline'
alias screen-connect='.config/scripts/screen-connect.sh'
