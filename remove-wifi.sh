#!/bin/sh -exu
if [ "$(id -u)" == "0" ]; then
   echo "This script must not be run as root" 1>&2
   exit 1
fi
dev=$1
cd $(mktemp -d)

function cleanup {
  sudo umount root || true
}

mkdir -p root
sudo mount ${dev}2 root
trap cleanup EXIT

cat <<EOF >pacman.conf
[options]
SigLevel = Never

[core]
Server = http://mirror.archlinuxarm.org/\$arch/\$repo

[extra]
Server = http://mirror.archlinuxarm.org/\$arch/\$repo

[community]
Server = http://mirror.archlinuxarm.org/\$arch/\$repo

[alarm]
Server = http://mirror.archlinuxarm.org/\$arch/\$repo

[aur]
Server = http://mirror.archlinuxarm.org/\$arch/\$repo
EOF

pacman="pacman -r root --arch armv6h --config pacman.conf --cachedir root/var/cache/pacman/pkg --dbpath root/var/lib/pacman"

sudo $pacman -Sy
echo "You can safely ignore an execv error message about being unable to create a link"
sudo $pacman --noconfirm -R wpa_actiond

sudo rm root/etc/systemd/system/multi-user.target.wants/netctl-auto@wlan0.service || true
sudo rm root/etc/netctl/wlan0 || true
