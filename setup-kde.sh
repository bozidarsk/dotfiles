sudo pacman -Syu plasma konsole dolphin

mv $dotfiles/.config/pulsemeeter .config/
mv $dotfiles/.config/sublime-text/Packages .config/sublime-text/
mv $dotfiles/.config/kcminputrc .config/
mv $dotfiles/.config/kdeglobals .config/
mv $dotfiles/.config/kscreenlockerrc .config/
mv $dotfiles/.config/ksplashrc .config/
mv $dotfiles/.config/kwinrc .config/
mv $dotfiles/.config/plasmarc .config/
mv $dotfiles/.config/dolphinrc .config/
mv $dotfiles/.config/konsolerc .config/
mv $dotfiles/.config/plasmashellrc .config/
mv $dotfiles/.config/spectaclerc .config/
mv $dotfiles/.config/systemsettingsrc .config/
mv $dotfiles/.config/kglobalshortcutsrc .config/
mv $dotfiles/.config/khotkeysrc .config/
mv $dotfiles/.config/kiorc .config/
mv $dotfiles/.config/klipperrc .config/
mv $dotfiles/.config/kmenueditrc .config/
mv $dotfiles/.config/kxkbrc .config/
mv $dotfiles/.config/plasma-localerc .config/
mv $dotfiles/.config/plasmawindowed-appletsrc .config/
mv $dotfiles/.config/powermanagementprofilesrc .config/
mv $dotfiles/.config/kded5rc .config/

cat $dotfiles/gsettings/kde | sed -E 's/(.+)/gsettings set \1/' > /tmp/gsettings.sh
chmod +x /tmp/gsettings.sh
/tmp/gsettings.sh 

# for android-sdk
sudo pacman -Syu jdk-openjdk libxtst fontconfig freetype2 lib32-gcc-libs lib32-glibc libx11 libxext libxrender zlib
installaur thorium-browser-bin spotify pulsemeeter-git sublime-text-4 unityhub android-sdk celluloid-git

echo "Set GloblaTheme to 'Nordic-bluish'"
echo "Set SplashScreen to 'Arch Simple Blue'"

sudo rm -rf $dotfiles
