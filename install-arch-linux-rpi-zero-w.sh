#!/bin/sh -exu
if [ "$(id -u)" == "0" ]; then
   echo "This script must not be run as root" 1>&2
   exit 1
fi

dev=$1
tmp=$(mktemp -d)

function cleanup {
    sudo umount $tmp/boot || true
    sudo umount $tmp/root || true
}

if [ $# -lt 2 ] ; then
  # RPi1/Zero (armv6h):
  archlinux=/tmp/ArchLinuxARM-rpi-latest.tar.gz
  url=http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz

  # RPi2 (armv7h):
  # archlinux=/tmp/ArchLinuxARM-rpi-2-latest.tar.gz
  # url=http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz

  curl -L -o $archlinux -z $archlinux $url
else
  archlinux=$2
fi

if ! [ -f $archlinux ] ; then
  echo "File not found: $archlinux"
  exit 1
fi

sudo parted -s $dev mklabel msdos
sudo parted -s $dev mkpart primary fat32 1 128
sudo parted -s $dev mkpart primary ext4 128 -- -1
sudo mkfs.vfat ${dev}1
sudo mkfs.ext4 -F ${dev}2
mkdir -p $tmp/boot
sudo mount ${dev}1 $tmp/boot
trap cleanup EXIT
mkdir -p $tmp/root
sudo mount ${dev}2 $tmp/root

sudo bsdtar -xpf $archlinux -C $tmp/root
sudo mv $tmp/root/boot/* $tmp/boot
sudo sync
