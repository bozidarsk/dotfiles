#!/bin/zsh

set -e

printf 'timezone: '
read timezone
printf 'gitname: '
read gitname
printf 'gitemail: '
read gitemail
printf 'printerip: '
read printerip
printf 'printername: '
read printername
printf 'dotfiles: '
read dotfiles

dinitctl enable pipewire
dinitctl enable pipewire-pulse
dinitctl enable wireplumber

sudo ufw enable
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow from $printerip
sudo ufw allow to $printerip

echo "UUID=8C346B12346AFE98 /mnt/external ntfs defaults,uid=$UID,gid=$GID 0 2" | sudo tee -a /etc/fstab

sudo ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
sudo hwclock --systohc
sudo dinitctl enable ntpd

echo 'export LANG="en_US.UTF-8"' | sudo tee -a /etc/locale.conf
echo 'export LC_TIME="en_GB.UTF-8"' | sudo tee -a /etc/locale.conf
echo "FONT=eurlatgr" | sudo tee -a /etc/vconsole.conf

sudo lpadmin -p "$printername" -E -v "ipp://$printerip/ipp/print" -m everywhere
sudo lpadmin -p PDF -E -v "cups-pdf:/" -m CUPS-PDF_opt.ppd
sudo lpoptions -d "$printername"

cd ~

if [[ "$edev" != "" ]]; then
    ln -sr /mnt/external/Projects Projects
fi

dirs=(.local/share/applications .config .cache Desktop Documents Music Pictures/Screenshots Pictures/Wallpapers Videos Downloads 'Google Drive' 'Proton Drive')
for dir in ${dirs[*]}; do
	if [[ ! -d "$dir" ]]; then
		mkdir -p "$dir"
	fi
done

mkdir /tmp/thumbnails
ln -sr /tmp/thumbnails .cache/thumbnails

mv $dotfiles/.themes .
mv $dotfiles/.icons .
ln -sr ".themes/Colloid-Dark-Nord/gtk-3.0" .config/gtk-3.0
ln -sr ".themes/Colloid-Dark-Nord/gtk-4.0" .config/gtk-4.0

mv $dotfiles/.config/zed .config

mv $dotfiles/wallpapers/* Pictures/Wallpapers

mv $dotfiles/.desktop/* .local/share/applications/

ssh-keygen -t ed25519 -C "$gitemail"

curl https://gist.githubusercontent.com/bozidarsk/0fd6584ed7b52e5b24768569e49728be/raw/0cae895abf7f391f840fc153dbded9e799a9b33a/.gitignore > .gitignore
git config --global init.defaultBranch main
git config --global user.email "$gitemail"
git config --global user.name "$gitname"
git config --global --add safe.directory '*'
git config --global core.excludesfile .gitignore
git config --global core.autocrlf false
git config --global push.autoSetupRemote true
git config --global gpg.format ssh
git config --global user.signingKey ~/.ssh/id_ed25519
git config --global commit.gpgSign true
git config --global tag.gpgSign true

git clone https://aur.archlinux.org/installaur-git.git /tmp/installaur
cd /tmp/installaur
makepkg -si
cd ~

installaur clapper-git zen-browser-bin unityhub wlrobs minecraft-launcher looking-glass mkinitcpio-firmware
installaur android-sdk android-sdk-cmdline-tools-latest android-sdk-build-tools android-sdk-platform-tools android-emulator

docker container create --name mysql-server -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -e MYSQL_ROOT_PASSWORD= mysql:latest

export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"
ANDROID_TOOLS="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

sudo $ANDROID_TOOLS/sdkmanager --install "system-images;android-36;google_apis_playstore;x86_64" "platforms;android-36"
$ANDROID_TOOLS/avdmanager create avd --name test --package "system-images;android-36;google_apis_playstore;x86_64" --device pixel_9

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
