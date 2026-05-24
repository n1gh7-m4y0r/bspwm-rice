
PKG_FILE="./packages.txt"

read -p "Start installation progress? [y/n]: " confirm
while [[ "$confirm" != "y" ]]; do
    exit
done

######################################################################################################################################################

if [ ! -f "$PKG_FILE" ]; then
    echo "Ошибка: Файл $PKG_FILE не найден!"
    exit 1
fi

######################################################################################################################################################



######################################################################################################################################################

echo ""
echo "=== trying to find yay ==="
echo ""
sleep 1

if ! command -v yay &> /dev/null; then
    echo "yay not found :("
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd
fi

sleep 2

echo "=== yay installed ==="
sleep 1
clear

######################################################################################################################################################

echo ""
echo "=== install yay pack ==="
echo ""
sleep 1

awk '$2=="yay" {print $1}' "$PKG_FILE" | xargs -r yay -S --needed --noconfirm
sleep 2
clear

######################################################################################################################################################



######################################################################################################################################################

echo ""
echo "=== install config files.... ==="

sudo cp -r ./dotfiles/bashrc $HOME/.bashrc

sudo mkdir -p $HOME/.config/
sudo cp -r ./dotfiles/config/* $HOME/.config/

sudo mkdir -p $HOME/.local/
sudo cp -r ./dotfiles/local/* $HOME/.local/

sudo mkdir -p $HOME/.oh-my-bash/
sudo cp -r ./dotfiles/oh-my-bash/* $HOME/.oh-my-bash/

sudo mkdir -p $HOME/.scripts/
sudo cp -r ./dotfiles/scripts/* $HOME/.scripts/

sudo cp -r ./dotfiles/xinitrc $HOME/.xinitrc

sudo cp -r ./dotfiles-root/usr/share/themes/* /usr/share/themes/

sudo chown -R $USER:$USER ~/

startx
