set -e

printf 'dotfiles: '
read dotfiles

sudo pacman -Syu hyprland xdg-desktop-portal-hyprland hyprpaper hyprpicker hyprlock alacritty nemo grim slurp rofi wl-clip-persist quickshell

mv $dotfiles/.config/alacritty .config/
mv $dotfiles/.config/cliphistory .config/
mv $dotfiles/.config/hypr .config/
mv $dotfiles/.config/media-menu .config/
mv $dotfiles/.config/power-menu .config/
mv $dotfiles/.config/pulsemeeter .config/
mv $dotfiles/.config/sound-menu .config/
mv $dotfiles/.config/sublime-text/Packages .config/sublime-text/
mv $dotfiles/.config/swaync .config/
mv $dotfiles/.config/waybar .config/
mv $dotfiles/.config/wifi-menu .config/
mv $dotfiles/.config/wofi .config/
mv $dotfiles/.config/quickshell .config/

cat $dotfiles/settings/hyprland | sed -E 's/(.+)/gsettings set \1/' > /tmp/gsettings.sh
chmod +x /tmp/gsettings.sh
/tmp/gsettings.sh 

sudo rm -rf $dotfiles
