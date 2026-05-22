set -e

printf 'dotfiles: '
read dotfiles

sudo pacman -Sy hyprland xdg-desktop-portal-hyprland hyprpaper hyprpicker hyprlock alacritty nemo grim slurp rofi wl-clip-persist quickshell

mv $dotfiles/.config/hypr .config/
mv $dotfiles/.config/quickshell .config/
mv $dotfiles/.config/alacritty .config/

cat settings/hyprland.gsettings | sed -E 's/([^ ]+) ([^ ]+) (.+)/gsettings set \1 \2 \"\3\"/' > /tmp/gsettings.sh
chmod +x /tmp/gsettings.sh
/tmp/gsettings.sh 

sudo rm -rf $dotfiles
