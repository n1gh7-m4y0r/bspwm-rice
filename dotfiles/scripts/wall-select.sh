#!/bin/bash
set -e

# Стартовая папка (можно поменять)
START_DIR="$HOME/.config/wallpaper/"

# Если часто ходишь и в screenshots — можно открыть несколько вкладок:
# ranger "$HOME/Pictures" "$HOME/Pictures/screenshots" --choosefile=/tmp/.chosen_wall

CHOSEN_FILE="$(mktemp -u /tmp/.chosen_wall_XXXXXX)"
ranger --choosefile="$CHOSEN_FILE" "$START_DIR"

# Если отменили выбор — выходим
[ ! -s "$CHOSEN_FILE" ] && exit 0

IMG="$(cat "$CHOSEN_FILE")"
rm -f "$CHOSEN_FILE"

# Устанавливаем обои
# Варианты: --bg-fill / --bg-scale / --bg-center
feh --bg-fill "$IMG"

