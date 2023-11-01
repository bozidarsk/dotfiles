dotfiles=/usr/dotfiles

sudo pacman -Syu hyprland hyprpaper waybar wofi evemu alacritty grim slurp nemo

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

cat $dotfiles/gsettings/hyprland | sed -E 's/(.+)/gsettings set \1/' > /tmp/gsettings.sh
chmod +x /tmp/gsettings.sh
/tmp/gsettings.sh 

installaur hyprpicker-git swaync wifi-menu-git #media-menu-git sound-menu-git power-menu-git cliphistory-git

echo "export GTK_THEME=Colloid-Dark-Nord" >> ~/.zshenv
echo "export ICON_THEME=Colloid-teal-nord" >> ~/.zshenv
echo "export CURSOR_THEME=Win-8.0-NS" >> ~/.zshenv

sudo rm -rf $dotfiles
