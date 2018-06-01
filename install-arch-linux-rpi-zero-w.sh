#!/bin/sh -exu
if [ "$(id -u)" == "0" ]; then
   echo "This script must not be run as root" 1>&2
   exit 1
fi

dev=$1
cd $(mktemp -d)

function umountboot {
    sudo umount boot || true
    sudo umount root || true
}

# RPi1/Zero (armv6h):
archlinux=/tmp/ArchLinuxARM-rpi-latest.tar.gz
url=http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz

# RPi2 (armv7h):
# archlinux=/tmp/ArchLinuxARM-rpi-2-latest.tar.gz
# url=http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz

curl -L -o $archlinux -z $archlinux $url
sudo parted -s $dev mklabel msdos
sudo parted -s $dev mkpart primary fat32 1 128
sudo parted -s $dev mkpart primary ext4 128 -- -1
sudo mkfs.vfat ${dev}1
sudo mkfs.ext4 -F ${dev}2
mkdir -p boot
sudo mount ${dev}1 boot
trap umountboot EXIT
mkdir -p root
sudo mount ${dev}2 root

sudo bsdtar -xpf $archlinux -C root
sudo sync
sudo mv root/boot/* boot
