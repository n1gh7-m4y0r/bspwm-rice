#!/bin/bash
cd
# Функция для реального прогресс-бара по количеству файлов
real_progress_bar() {
    local total_files=$1
    local current=0
    local width=40  # ширина прогресс-бара
    while IFS= read -r file; do
        rm -rf "$file"
        current=$((current + 1))
        percent=$((current * 100 / total_files))
        done_bar=$((current * width / total_files))
        empty_bar=$((width - done_bar))
        printf "\r["
        for ((i=0;i<done_bar;i++)); do printf "="; done
        for ((i=0;i<empty_bar;i++)); do printf " "; done
        printf "] %d%%" "$percent"
    done
    echo
}

# Функция для размера папки в байтах
folder_size_bytes() {
    du -sb "$1" 2>/dev/null | awk '{print $1}'
}

# Инициализация счётчика освобождённой памяти
total_freed=0

echo "🧹 Чистим систему..." && sleep 3

# Очистка кэша pacman
pacman_cache="/var/cache/pacman/pkg"
echo "Очистка кэша pacman..."
size=$(folder_size_bytes "$pacman_cache")
if [[ -d "$pacman_cache" ]]; then
    total_files=$(find "$pacman_cache" -type f | wc -l)
    find "$pacman_cache" -type f | real_progress_bar $total_files
fi
sudo pacman -Scc --noconfirm
total_freed=$((total_freed + size))

sleep 3
# Очистка кэша yay
yay_cache="$HOME/.cache/yay"
echo "Очистка кэша yay..."
size=$(folder_size_bytes "$yay_cache")
if [[ -d "$yay_cache" ]]; then
    total_files=$(find "$yay_cache" -type f | wc -l)
    find "$yay_cache" -type f | real_progress_bar $total_files
fi
yay -Scc --noconfirm
total_freed=$((total_freed + size))
sleep 3
# Очистка логов
logs="/var/log"
echo "Очистка логов..."
size=$(folder_size_bytes "$logs")
if [[ -d "$logs" ]]; then
    total_files=$(find "$logs" -type f | wc -l)
    find "$logs" -type f | sudo bash -c 'while read f; do rm -f "$f"; echo; done' | real_progress_bar $total_files
fi
sudo rm -rf "$logs"/*
total_freed=$((total_freed + size))

sleep 3

# Очистка tmp
tmp="/tmp"
echo "Очистка временных файлов /tmp..."
size=$(folder_size_bytes "$tmp")
if [[ -d "$tmp" ]]; then
    total_files=$(find "$tmp" -type f | wc -l)
    find "$tmp" -type f | real_progress_bar $total_files
fi
sudo rm -rf "$tmp"/*
total_freed=$((total_freed + size))

sleep 3
# Очистка пользовательского кэша
user_cache="$HOME/.cache"
echo "Очистка пользовательского кэша..."
size=$(folder_size_bytes "$user_cache")
if [[ -d "$user_cache" ]]; then
    total_files=$(find "$user_cache" -type f | wc -l)
    find "$user_cache" -type f | real_progress_bar $total_files
fi
rm -rf "$user_cache"/*
total_freed=$((total_freed + size))

sleep 3
# Очистка корзины
trash="$HOME/.local/share/Trash"
root_trash="/root/.local/share/Trash"
echo "Очистка корзины..."
size_user=$(folder_size_bytes "$trash")
size_root=$(folder_size_bytes "$root_trash")
if [[ -d "$trash" ]]; then
    total_files=$(find "$trash" -type f | wc -l)
    find "$trash" -type f | real_progress_bar $total_files
fi
if [[ -d "$root_trash" ]]; then
    total_files=$(find "$root_trash" -type f | wc -l)
    sudo find "$root_trash" -type f | real_progress_bar $total_files
fi
rm -rf "$trash"/*
sudo rm -rf "$root_trash"/*
total_freed=$((total_freed + size_user + size_root))
sleep 3

# Очистка осиротевших пакетов
echo "Очистка осиротевших пакетов..."
orphans=$(pacman -Qdtq)
orphans_size=0
if [[ ! -z "$orphans" ]]; then
    for pkg in $orphans; do
        pkg_size=$(pacman -Qi $pkg | awk '/Installed Size/ {print $4}')
#        orphans_size=$((orphans_size + pkg_size * 1024))
    done
    sudo pacman -Rns --noconfirm $orphans
fi
total_freed=$((total_freed + orphans_size))
sleep 3

# Вывод освобождённой памяти
freed_mb=$(echo "scale=1; $total_freed/1024/1024" | bc)

echo
echo "✅ Система почищена!"
#echo "Объём освобождённой памяти: $(numfmt --to=iec-i --suffix=B $total_freed)"

#echo "Объём освобождённой памяти: ${freed_mb} MB"





# Подтверждение перед очисткой терминала
read -p "Продолжить и очистить терминал? [y/n]: " confirm
while [[ "$confirm" != "y" ]]; do
    echo "Я подожду, :)"
    read -p "Продолжить и очистить терминал? [y/n]: " confirm
done

# Очистка терминала с прогресс-баром
echo "Очистка терминала..."
for i in {1..40}; do
    sleep 0.05
    printf "\r[%-40s]" $(printf '#%.0s' $(seq 1 $i))
done
echo "|      Система полностью очищена ✅"
sleep 3
clear
