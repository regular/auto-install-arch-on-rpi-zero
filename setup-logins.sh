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

$script_dir/autologin.expect $script_dir/piemu.sh $dev $NEW_USER "$ADDITIONAL_PACKAGES"
