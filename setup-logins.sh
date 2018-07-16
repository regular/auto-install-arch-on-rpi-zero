#!/bin/sh -exu

if [ $# -lt 2 ] ; then
  echo "Usage: $0 sdcard-device config">&2
  exit 1
fi

if [ "$(id -u)" == "0" ]; then
   echo "This script must not be run as root" 1>&2
   exit 1
fi


script_dir=$(cd `dirname $0` && pwd)
dev=$1
config=$2

source "$(dirname $config)/$(basename $config)"
if ! [ -v NEW_USER ]; then NEW_USER=$USER; fi
if ! [ -v ADDITIONAL_PACKAGES ]; then ADDITIONAL_PACKAGES=""; fi
if ! [ -v IMPORT_FILES ]; then IMPORT_FILES=""; fi
if ! [ -v CUSTOM_SCRIPT ]; then CUSTOM_SCRIPT=""; fi

tmp=$(mktemp -d)

function cleanup {
  sync
  sudo umount $tmp/boot || true
  sudo umount $tmp/root || true
  sudo umount $tmp/aux || true
  sudo mount ${dev}2 $tmp/root || true
  sudo mv $tmp/fstab $tmp/root/etc/fstab || true
  sudo mount ${dev}1 $tmp/boot || true
  sudo cp -r $tmp/root/boot/* $tmp/boot
  sudo umount $tmp/boot || true
  sudo umount $tmp/root || true
  sudo chmod 700 ${dev}
}

## Copy user files to loopback device
mkdir -p $tmp/aux
dd if=/dev/zero of=$tmp/disk bs=1M count=32
mkfs.ext4 $tmp/disk
sudo mount -o loop $tmp/disk $tmp/aux
trap cleanup EXIT

if ! [ -z IMPORT_FILES -a -z CUSTOM_SCRIPT ]; then 
  sudo cp -r $CUSTOM_SCRIPT $IMPORT_FILES $tmp/aux
fi
sudo umount $tmp/aux || true

# copy boot files
mkdir -p $tmp/root
sudo mount ${dev}2 $tmp/root
mkdir -p $tmp/boot
sudo mount ${dev}1 $tmp/boot
sudo cp -r $tmp/boot/* $tmp/root/boot
sudo umount $tmp/boot
# move fstab out of the way, so
# we dont timeout on waiting for 
# mmc....
sudo mv $tmp/root/etc/fstab $tmp/fstab
sudo umount $tmp/root
sudo chmod 777 ${dev}

"$script_dir/autologin.expect" \
  "$script_dir/piemu.sh" \
  "$dev" \
  "$NEW_USER" \
  "$ADDITIONAL_PACKAGES" \
  "$tmp/disk" \
  "$(basename "$CUSTOM_SCRIPT")"
