printf 'enter drive device (/dev/X): '
read drive
printf 'enter grub target: '
read target
printf 'enter a mountpoint: '
read mountpoint

pacman -Sy edk2-shell wimlib libarchive cdrtools

echo "create partitions with enough size for every iso +one (the first one) main partition ~500M in size, all with 'EFI System' type 1 (uuid starts with 'C12')"
fdisk $drive

mkdir -p "$mountpoint"

mkfs.fat -F 32 "$drive"1
mount "$drive"1 "$mountpoint"
cd "$mountpoint"
grub-install --force --removable --target=$target --boot-directory="$mountpoint"/boot --efi-directory="$mountpoint" $device
curl 'https://raw.githubusercontent.com/bozidarsk/dotfiles/refs/heads/Linux/grub-usb.cfg' > "$mountpoint"/boot/grub/grub.cfg
cp /usr/share/edk2-shell/x64/Shell_Full.efi ./shell-x64.efi
cp /usr/share/edk2-shell/ia32/Shell_Full.efi ./shell-ia32.efi
cp /usr/share/edk2-shell/arm/Shell_Full.efi ./shell-arm.efi
cp /usr/share/edk2-shell/aarch64/Shell_Full.efi ./shell-arm64.efi
umount "$mountpoint"

mkdir "$mountpoint-isoextract"
for x in $(blkid -o device | grep $drive | grep -v "$drive"1); do
	mkfs.fat -F 32 $x
	mount $x "$mountpoint"
	mount aaa.iso "$mountpoint-isoextract"
	cp -rL "$mountpoint-isoextract"/* "$mountpoint"
	umount "$mountpoint-isoextract"
	umount "$mountpoint"
done
rmdir "$mountpoint-isoextract"

rmdir "$mountpoint"

# curl 'https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso' -o archlinux-x86_64.iso
# curl 'https://gemmei.ftp.acc.umu.se/debian-cd/current-live/amd64/iso-hybrid/debian-live-12.7.0-amd64-standard.iso' -o debian-live-12.7.0-amd64-standard.iso

# windows has a file (sources/install.wim) that is too big for fat32 so you need to split it into chunks
# cd extract/sources
# wimsplit install.wim install.swm 500
# cp *.swm ../../Win11_24H2_English_x64/sources
