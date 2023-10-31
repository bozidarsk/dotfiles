dotfiles=/usr/dotfiles

sudo pacman -Syu gdm gnome-shell gnome-shell-extensions gnome-terminal gnome-control-center gnome-tweaks ttf-liberation xdg-utils libcurl-gnutls libadwaita libxss networkmanager dconf-editor nemo

sudo systemctl enable gdm
sudo systemctl enable NetworkManager
sudo systemctl disable iwd

mv $dotfiles/.config/pulsemeeter .config/
mv $dotfiles/.config/sublime-text/Packages .config/sublime-text/

cat $dotfiles/gsettings/gnome | sed -E 's/(.+)/gsettings set \1/' > /tmp/gsettings.sh
chmod +x /tmp/gsettings.sh
/tmp/gsettings.sh 

installaur gnome-browser-connector

sudo rm -rf $dotfiles
