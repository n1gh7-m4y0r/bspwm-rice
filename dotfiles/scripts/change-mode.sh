#!/bin/bash

pkill bspwm_notify_si

pkill polybar

alacritty --config-file ~/.scripts/alacritty-config/alacritty.toml --class black-back -e watch -n 1 read &

~/.scripts/picom-start.sh

feh --bg-fill ~/.config/wallpaper/Black-Background-Design-High-Definition-Wallpaper-40665.jpg

choice=$(printf "Look better\nGame mode\nMinimal Mode\nYoutube" | rofi -config ~/.scripts/rofi-theme/config.rasi -dmenu -p "Запуск")

case "$choice" in
    "Look better")
        ~/.scripts/look-better.sh
        ;;
    "Game mode")
        ~/.scripts/game-mode.sh
        ;;
    "Minimal Mode")
	~/.scripts/none-mode.sh
	;;
    "Youtube")
	~/.scripts/youtube.sh
	;;
esac

pkill watch
