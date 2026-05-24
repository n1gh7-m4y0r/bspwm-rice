#!/bin/sh
sxhkd -c /home/sheyn/.config/sxhkd/sxhkdrc &
~/.scripts/bspwm_notify_size_pos.sh &
bash ~/.scripts/picom-start.sh &
bash ~/.config/polybar/launch.sh --forest &
feh --bg-fill --random ~/.config/wallpaper/ &
