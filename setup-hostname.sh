#!/bin/sh -exu
if [ "$(id -u)" == "0" ]; then
   echo "This script must not be run as root" 1>&2
   exit 1
fi

source ./config
if [ -z $NEW_HOSTNAME ]; then NEW_HOSTNAME=arch-raspi; fi

dev=$1
tmp=$(mktemp -d)

function cleanup {
  sudo umount $tmp/root || true
}

mkdir -p $tmp/root
sudo mount ${dev}2 $tmp/root
trap cleanup EXIT
echo "$NEW_HOSTNAME" | sudo tee $tmp/root/etc/hostname

