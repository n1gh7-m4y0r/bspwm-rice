# Arch Linux + my bspwm rice Installation guide

---

# 1. Connect to Wi-Fi

You can find out your wireless interface with the command: "device list" from iwctl

```bash
iwctl
station <your_interface> connect <your_wifi>
```

---

# 2. Configure pacman

Edit:

```bash
nano /etc/pacman.conf
```

Enable:

```ini
ParallelDownloads = 300
```

Update mirrors:

```bash
pacman -Sy
```

---

# 3. Partition disks


You can find out your disk layout with the command: "lsblk"

```bash
cfdisk /dev/<your_disk>

mkfs.ext4 /dev/<your_partition>

mount /dev/<your_partition> /mnt
```

---

# 4. Install base system

```bash
pacstrap -K /mnt \
base base-devel linux linux-firmware linux-headers \
nano git grub os-prober iwd dhcpcd
```

---

# 5. Generate fstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

---

# 6. Chroot into system

```bash
arch-chroot /mnt
```

---

# 7. Configure system

Enable multilib: (remove # from the multilib line)
And change ParallelDownload to 100 or highter

```bash
nano /etc/pacman.conf
```

Update system:

```bash
pacman -Syu
```

---

# 8. Create user

```bash
useradd -m <username>

passwd <username>

passwd
```

Add user to sudoers:

```bash
EDITOR=nano visudo
```

OR

```bash
sudo nano /etc/sudoers
```

---

# 9. Configure locale & timezone

```bash
nano /etc/locale.gen

locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

ln -sf /usr/share/zoneinfo/<region>/<city> /etc/localtime

hwclock --systohc
```

---

# 10. Install GRUB

```bash
grub-install /dev/<your_disk>

grub-mkconfig -o /boot/grub/grub.cfg
```

---

# 11. Reboot

```bash
exit
reboot
```

---

# After reboot

## Enable networking

```bash
sudo systemctl enable --now iwd

sudo systemctl enable --now dhcpcd
```

Connect to Wi-Fi:

```bash
sudo iwctl

station <your_interface> connect <your_wifi>
```

---

# Update system

```bash
sudo pacman -Syu
```

---

# Install rice

```bash
git clone https://github.com/n1gh7-m4y0r/bspwm-rice

cd bspwm-rice

```

Edit packages.txt if you are an experienced user, otherwise some system settings may not work.

# And run the automatic scripts

```bash

./pacman_pack-install.sh
./yay_pack-install.sh

```

If you have an automatic script at the moment, try restarting the scripts; this often solves the error
