user=bozidarsk
hostname=archbtw
dotfiles=/usr/dotfiles

printf "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" >> /etc/pacman.conf
pacman -Sy vim openssh sudo ntfs-3g ufw base-devel git zsh python3 python-pip brightnessctl pulseaudio ufw unzip wl-clipboard gtk4 rclone dosfstools exfatprogs cups cups-pdf sane-airscan mono gtk-sharp-3 gtk-layer-shell nasm qemu-system-x86 arduino-cli obs-studio android-udev android-file-transfer htop mpv x265 x264 gtk4 libadwaita rclone discord evemu

systemctl enable sshd
systemctl enable cups

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
cd "/home/$user"

mkdir /mnt/android
mkdir /mnt/external
echo "/dev/sdb1 /mnt/external ntfs defaults 0 2" >> /etc/fstab

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
