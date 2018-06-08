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

tmp=$(mktemp -d)

function cleanup {
  sudo umount $tmp/aux || true
  sudo mount ${dev}2 $tmp/root || true
  sudo mv $tmp/fstab $tmp/root/etc/fstab || true
  sudo umount $tmp/root || true
  sudo chmod 700 ${dev}
}

## Copy user files to loopback device
mkdir -p $tmp/aux
dd if=/dev/zero of=$tmp/disk bs=1M count=32
mkfs.ext4 $tmp/disk
sudo mount -o loop $tmp/disk $tmp/aux
trap cleanup EXIT

if ! [ -z IMPORT_FILES && -z CUSTOM_SCRIPT ]; then 
  sudo cp -r "$CUSTOM_SCRIPT" $IMPORT_FILES $tmp/aux
fi
sudo umount $tmp/aux || true

# move fstab out of the way, so
# we dont timeout on waiting for 
# mmc....
mkdir -p $tmp/root
sudo mount ${dev}2 $tmp/root
sudo mv $tmp/root/etc/fstab $tmp/fstab
sudo umount $tmp/root
sudo chmod 777 ${dev}

"$script_dir/interact.expect" \
  "$script_dir/piemu.sh" \
  "$dev" \
  "$NEW_USER" \
  "$tmp/disk"
