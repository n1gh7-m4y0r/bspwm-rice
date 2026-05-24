#! /bin/sh
# CLOCK
alacritty --class tty_clock -e tty-clock -c -C 7 &
# RAIN
alacritty --class rain -e terminal-rain &
# CAVA 
alacritty --class cava_term -e cava &
# WALL
feh --bg-fill .config/wallpaper/Black-Adam-PC-Wallpaper-4k-1-2048x1152.jpg
