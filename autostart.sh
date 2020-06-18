#!/usr/bin/env sh

~/.screenlayout/default.sh
setxkbmap us -variant colemak -option "caps:escape"
xset m 0 0
picom --config ~/.config/picom/picom.conf &
nitrogen --restore &
