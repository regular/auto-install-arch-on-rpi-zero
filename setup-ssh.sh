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
tmp=$(mktemp -d)

function cleanup {
  sudo umount $tmp/root || true
}

mkdir -p $tmp/root
sudo mount ${dev}2 $tmp/root
trap cleanup EXIT

sudo $script_dir/ssh_harden.sh a "$tmp/root/etc/ssh/sshd_config" "$config"
