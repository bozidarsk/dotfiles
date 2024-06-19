timezone="Europe/Sofia"
gitname="bozidarsk"
gitemail="bozidarkabahcijski@gmail.com"
printerip='192.168.1.10'
printername=TS6250
dotfiles=/usr/dotfiles

systemctl --user enable pipewire

sudo ufw enable
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow from $printerip
sudo ufw allow to $printerip

sudo timedatectl set-timezone "$timezone"
sudo timedatectl set-ntp true

sudo localectl set-locale LANG="en_US.UTF-8"
sudo localectl set-locale LC_TIME="en_GB.UTF-8"
sudo localectl set-keymap us
sudo localectl set-x11-keymap us

sudo lpadmin -p "$printername" -E -v "ipp://$printerip/ipp/print" -m everywhere
sudo lpadmin -p PDF -E -v "cups-pdf:/" -m CUPS-PDF_opt.ppd
sudo lpoptions -d "$printername"

cd ~
ln -sr /mnt/external/Projects Projects

mkdir .local
mkdir .local/share
mkdir .local/share/applications
mkdir .config
mkdir .config/sublime-text
mkdir Videos
mkdir Pictures
mkdir Documents

mv $dotfiles/.themes .
mv $dotfiles/.icons .
ln -sr ".themes/Colloid-Dark-Nord/gtk-3.0" .config/gtk-3.0
ln -sr ".themes/Colloid-Dark-Nord/gtk-4.0" .config/gtk-4.0

mv $dotfiles/.config/pulsemeeter .config/
mv $dotfiles/.config/sublime-text/Packages .config/sublime-text/

mv $dotfiles/wallpapers Pictures/Wallpapers

mv $dotfiles/.desktop/* .local/share/applications/
echo "x-scheme-handler/cs=cs.desktop" >> .config/mimeapps.list
echo "x-scheme-handler/sof=sof.desktop" >> .config/mimeapps.list

curl https://gist.githubusercontent.com/bozidarsk/0fd6584ed7b52e5b24768569e49728be/raw/0cae895abf7f391f840fc153dbded9e799a9b33a/.gitignore > .gitignore
git config --global init.defaultBranch main
git config --global user.email "$gitemail"
git config --global user.name "$gitname"
git config --global --add safe.directory '*'
git config --global core.excludesfile .gitignore
git config --global credential.helper store
git config --global core.autocrlf false
git config --global push.autoSetupRemote true

git clone https://aur.archlinux.org/installaur-git.git /tmp/installaur
cd /tmp/installaur
makepkg -si
cd ~

# for android-sdk
sudo pacman -Syu jdk-openjdk libxtst fontconfig freetype2 lib32-gcc-libs lib32-glibc libx11 libxext libxrender zlib
installaur google-chrome spotify pulsemeeter-git sublime-text-4 unityhub android-sdk celluloid-git teams wlrobs

# WINE BEGIN
echo "WARNING: COMPILING WINE WILL TAKE A LOT OF TIME (HOURS), A LOT OF DISK SPACE (~5.5GB) AND ALL OF YOUR BATTERY"
printf "Do you want to proceed? [y/n] "
read answer
if [[ "$answer" =~ [yY][eE]?[sS]? ]]; then
    sudo pacman -Sy  lib32-libpulse
    # gpg --recv-keys ACEB29740C9A4E97 F9C3D6BDB8232B5D A48E86DB0B830498 7180713BE58D1ADC CEFAC8EAAF17519D
    installaur lib32-dav1d wine-stable
    sudo pacman -Sy wine-mono wine-gecko
    WINEARCH=win32 WINEPREFIX=~/.config/win32 winecfg
    WINEPREFIX=~/.config/win64 winecfg
fi
# WINE END

# scanimage -L
# scanimage -d "airscan:w0:CANON INC. TS6200 series" -p --format=png -o "$HOME/Documents/$(date +'%Y%d%m_%H%M%S').png"

#sudo ufw disable
#rclone config
# name> Google Drive
# Storage> drive
# client_id> # from https://console.cloud.google.com/apis/credentials?project=rclone-393205
# client_secret> # from https://console.cloud.google.com/apis/credentials?project=rclone-393205
# scope> drive
# Edit advanced condfig?
# y/n> n
# Already have a token - refresh?
# y/n> y
# Configure this as a Shared Drive (Team Drive)?
# y/n> n
# Configuration complete.
# e/n/d/r/c/s/q> q
#sudo ufw enable
