#!/usr/bin/env bash

## Based on the themes from the author below
## Extremelly adapted to my own setup
## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#

theme="$HOME/.config/rofi.beto/themes/red/launcher.rasi"

## Run
rofi \
    -show drun \
    -theme ${theme}
