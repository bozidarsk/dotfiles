sudo pacman -Syu gdm gnome-shell gnome-shell-extensions gnome-terminal gnome-control-center gnome-tweaks ttf-liberation xdg-utils libcurl-gnutls libadwaita libxss networkmanager dconf-editor nemo

sudo systemctl enable gdm
sudo systemctl enable NetworkManager
sudo systemctl disable iwd

mv $dotfiles/.config/pulsemeeter .config/
mv $dotfiles/.config/sublime-text/Packages .config/sublime-text/

cat $dotfiles/gsettings/gnome | sed -E 's/(.+)/gsettings set \1/' > /tmp/gsettings.sh
chmod +x /tmp/gsettings.sh
/tmp/gsettings.sh 

# for android-sdk
sudo pacman -Syu jdk-openjdk libxtst fontconfig freetype2 lib32-gcc-libs lib32-glibc libx11 libxext libxrender zlib
installaur thorium-browser-bin spotify gnome-browser-connector pulsemeeter-git sublime-text-4 unityhub android-sdk celluloid-git

sudo rm -rf $dotfiles
