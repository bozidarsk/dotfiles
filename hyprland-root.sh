user=bozidarsk
hostname=archbtw
SSID=Yana
dotfiles=/usr/dotfiles

iwctl station wlan0 connect "$SSID" 

pacman -Sy vim openssh sudo ntfs-3g
systemctl enable sshd

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

mkdir /mnt/win
mkdir /mnt/android
mkdir /mnt/external
mount /dev/sda2 /mnt/win
mount /dev/sdb1 /mnt/external
echo "/dev/sda2 /mnt/win ntfs defaults 0 2" >> /etc/fstab
echo "/dev/sdb1 /mnt/external ntfs defaults 0 2" >> /etc/fstab

chown "$user:$user" /mnt/win
chown "$user:$user" /mnt/android
chown "$user:$user" /mnt/external

chmod +s /usr/bin/iwctl
chmod +s /usr/bin/poweroff
chmod +s /usr/bin/reboot

printf "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" >> /etc/pacman.conf
pacman -Sy git vim hyprland hyprpaper waybar python3 python-pip zsh alacritty nemo ufw base-devel wofi brightnessctl pulseaudio unzip wl-clipboard grim slurp mpv x265 x264 gtk4 libadwaita rclone ntfs-3g dosfstools exfatprogs cups cups-pdf sane-airscan mono gtk-sharp-3 gtk-layer-shell nasm qemu-system-x86 arduino-cli obs-studio android-udev android-file-transfer htop evemu

mv $dotfiles/.zshrc "/home/$user"
mv $dotfiles/.zshenv "/home/$user"
chsh -s /bin/zsh "$user"

for script in $dotfiles/.sh/*.sh; do
    mv $script /usr/local/bin/$(basename "${script%.*}")
done

echo 'Out ${HOME}/Documents' >> /etc/cups/cups-pdf.conf
systemctl enable cups

ufw enable
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp

mv $dotfiles/fonts /usr/local/share/
fc-cache -fv

chown -R "$user:$user" "/home/$user"
chown -R "$user:$user" $dotfiles
