set -e

printf 'user: '
read user
printf 'hostname: '
read hostname
printf 'dotfiles: '
read dotfiles

dinitctl enable dhcpcd
dinitctl enable iwd

printf "\n[lib32]\nInclude = /etc/pacman.d/mirrorlist\n" >> /etc/pacman.conf
pacman -Syy \
    sudo man-db man-pages base-devel dinit-user-spawn glib2-devel qt6-wayland libadwaita gtk4 ttf-liberation \
    ntfs-3g dosfstools exfatprogs mtools libisoburn android-udev android-file-transfer \
    openssh openssh-dinit ntp ntp-dinit ufw ufw-dinit vim git zsh wget less tree zip unzip unrar gnu-netcat \
    zed dotnet-sdk mono nasm gtk-sharp-3 gtk-layer-shell rust docker docker-compose docker-dinit arduino-cli \
    qemu-full qemu-ui-gtk edk2-ovmf swtpm virt-viewer \
    cups cups-dinit cups-pdf sane sane-dinit avahi avahi-dinit \
    playerctl pipewire pipewire-dinit pipewire-pulse pipewire-pulse-dinit wireplumber wireplumber-dinit jack2 gstreamer gst-plugin-pipewire mpv x265 x264 ffmpegthumbnailer \
    steam gamemode lib32-gamemode \
    obs-studio blender loupe rclone htop brightnessctl wl-clipboard \
    jdk-openjdk libxtst fontconfig freetype2 lib32-gcc-libs lib32-glibc libx11 libxext libxrender zlib geocode-glib-2 \


dinitctl enable sshd
dinitctl enable cupsd
dinitctl enable avahi-daemon
dinitctl enable dockerd

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
