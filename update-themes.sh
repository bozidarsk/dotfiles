#!/bin/zsh

gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME"
gsettings set org.gnome.desktop.wm.preferences theme "$GTK_THEME"
gsettings set org.cinnamon.desktop.interface gtk-color-scheme prefer-dark
gsettings set org.cinnamon.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.cinnamon.desktop.interface icon-theme "$ICON_THEME"
gsettings set org.cinnamon.desktop.interface cursor-theme "$CURSOR_THEME"

rm -rf ~/.config/gtk-{3,4}.0

ln -sr ".themes/$GTK_THEME/gtk-3.0" ~/.config/gtk-3.0
ln -sr ".themes/$GTK_THEME/gtk-4.0" ~/.config/gtk-4.0
