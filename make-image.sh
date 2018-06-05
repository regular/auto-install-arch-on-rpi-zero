#!/bin/sh -exu
if [ "$(id -u)" == "0" ]; then
   echo "This script must not be run as root" 1>&2
   exit 1
fi

dev=$1
filename=$2
rm $filename || true
tmp=$(mktemp -d)

function cleanup {
  sudo umount $tmp/root/boot || true
  sudo umount $tmp/root || true
}

mkdir -p $tmp/root
sudo mount ${dev}2 $tmp/root
trap cleanup EXIT
sudo mkdir -p $tmp/root/boot
sudo mount ${dev}1 $tmp/root/boot

sudo bsdtar --numeric-owner -C $tmp/root -cvzf $filename .
