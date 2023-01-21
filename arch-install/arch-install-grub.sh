#!/bin/sh

acrh_user="lapuglisi";
if [ -n "$1" ]; then
    arch_user="$1";
fi

arch_hostname="archlinux";
if [ -n "$2" ].; then
    arch_hostname="$2";
fi

echo;
echo "##### Arch Linux Installer #####";
echo "== Will create user ..... '${arch_user}'.";
echo "== Hostname will be ..... '${arch_hostname}'.";
echo;

# set parallel downloads
sed -i.bak 's/#ParallelDownlodas = /ParallelDownloads = 5/' /etc/pacman.conf

# update system
pacman -Syy;
pacman -Fyy;

# set locales
sed -i.bak 's/#en_US.UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen;
sed -i.bak 's/#pt_BR.UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen;

# set locales
echo LANG="en_US.UTF-8" > /etc/locale.conf;
echo KEYMAP="br-abnt2" > /etc/vconsole.conf;

# hostname
echo "${arch_hostname}" > /etc/hostname;

# hosts
(
    echo -e "127.0.0.1\tlocalhost.local\tlocalhost";
    echo -e "127.0.1.1\t${arch_hostname}.local\t${arch_hostname}";
)

# set right services
pacman -Sy openssh networkmanager;
if [ $? -eq 0 ]; then
    systemctl disable systemd-networkd;
    systemctl disable systemd-resolved;

    systemctl enable sshd NetworkManager;
fi

# add new user
echo;
echo "=== Adding user '${arch_user}'...";
useradd -m "${arch_user}";
echo "=== Setting password for user '${arch_user}'...";
passwd ${arch_user};

echo;
echo "=== Setting password for root...";
passwd;

echo;
echo "Installing GRUB bootloader...";
pacman -Sy grub;
echo -n "[I] Enter target device for GRUB: ";
read grub_target;
grub-install ${grub_target};
grub-mkconfig -o /boot/grub/grub.cfg;

# sync everything
sync;

echo;
echo "=== Installation is completed ===";
echo;
