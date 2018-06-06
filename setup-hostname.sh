#!/bin/sh -exu

if [ $# -lt 2 ] ; then
  echo "Usage: $0 sdcard-device config">&2
  exit 1
fi

if [ "$(id -u)" == "0" ]; then
   echo "This script must not be run as root" 1>&2
   exit 1
fi

dev=$1
config=$2

source "$(dirname $config)/$(basename $config)"
if ! [ -v NEW_HOSTNAME ]; then NEW_HOSTNAME=arch-raspi; fi

tmp=$(mktemp -d)

function cleanup {
  sudo umount $tmp/root || true
}

mkdir -p $tmp/root
sudo mount ${dev}2 $tmp/root
trap cleanup EXIT
echo "$NEW_HOSTNAME" | sudo tee $tmp/root/etc/hostname

