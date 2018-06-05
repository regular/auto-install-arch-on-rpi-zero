#!/bin/sh -exu
if [ "$(id -u)" == "0" ]; then
   echo "This script must not be run as root" 1>&2
   exit 1
fi

source ./config
if [ -z $NEW_USER ]; then NEW_USER=$USER; fi

dev=$1
tmp=$(mktemp -d)

function cleanup {
  sudo mount ${dev}2 $tmp/root || true
  sudo mv $tmp/fstab $tmp/root/etc/fstab || true
  sudo umount $tmp/root || true
  sudo chmod 700 ${dev}
}

mkdir -p $tmp/root
sudo mount ${dev}2 $tmp/root
trap cleanup EXIT
sudo mv $tmp/root/etc/fstab $tmp/fstab
sudo umount $tmp/root
sudo chmod 777 ${dev}

./autologin.expect $(pwd)/piemu.sh $dev $NEW_USER "$ADDITIONAL_PACKAGES"

