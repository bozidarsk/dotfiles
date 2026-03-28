printf 'user: '
read user
printf 'hostname: '
read hostname
printf 'dotfiles: '
read dotfiles

dinitctl enable dhcpcd
dinitctl enable iwd

printf "\n[lib32-gremlins]\nInclude = /etc/pacman.d/mirrorlist\n\n" >> /etc/pacman.conf
printf "\n[lib32]\nInclude = /etc/pacman.d/mirrorlist\n\n" >> /etc/pacman.conf
pacman -Sy vim openssh sudo ntfs-3g ufw base-devel git zsh python3 python-pip brightnessctl pipewire pipewire-pulse ufw zip unzip unrar wl-clipboard gtk4 rclone dosfstools exfatprogs cups cups-pdf sane-airscan mono gtk-sharp-3 gtk-layer-shell nasm qemu-full arduino-cli obs-studio android-udev android-file-transfer htop mpv x265 x264 gtk4 libadwaita rclone discord evemu libisoburn mtools qemu-ui-gtk blender dotnet-sdk wget tree qt6-wayland gstreamer gst-plugin-pipewire glib2-devel iw steam gamemode lib32-gamemode xorg-xauth wireshark-cli docker docker-compose loupe ffmpegthumbnailer edk2-ovmf swtpm virt-viewer clapper man-db man-pages

echo 'X11Forwarding yes' >> /etc/ssh/sshd_config
echo 'AllowTcpForwarding yes' >> /etc/ssh/sshd_config
echo 'X11UseLocalhost yes' >> /etc/ssh/sshd_config
echo 'X11DisplayOffset 10' >> /etc/ssh/sshd_config

dinitctl enable sshd
dinitctl enable cups
dinitctl enable avahi-daemon.socket
dinitctl enable docker

echo 'Out ${HOME}/Documents' >> /etc/cups/cups-pdf.conf

echo "$hostname" > /etc/hostname
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

chmod +w /etc/sudoers
echo "%sudo ALL=(ALL:ALL) ALL" >> /etc/sudoers
chmod -w /etc/sudoers
mkdir "/home/$user"
groupadd sudo
useradd --home-dir "/home/$user" -G sudo "$user"
echo "Enter new password for '$user'."
passwd "$user"
chown -R "$user:$user" "/home/$user"
groupmems -g input -a "$user"
groupmems -g uucp -a "$user"
groupmems -g wireshark -a "$user"
groupmems -g docker -a "$user"
cd "/home/$user"

mkdir /mnt/external
mkdir /mnt/android
mkdir /mnt/usb

chown "$user:$user" /mnt/android
chown "$user:$user" /mnt/external

chmod +s /usr/bin/iwctl
chmod +s /usr/bin/poweroff
chmod +s /usr/bin/reboot

for script in $dotfiles/.sh/*.sh; do
    mv $script /usr/local/bin/$(basename "${script%.*}")
done

chmod +x /usr/local/bin/*

mv $dotfiles/fonts /usr/local/share/
fc-cache -fv

mv $dotfiles/.zshrc "/home/$user"
mv $dotfiles/.zshenv "/home/$user"
chsh -s /bin/zsh "$user"

chown -R "$user:$user" "/home/$user"
chown -R "$user:$user" $dotfiles
