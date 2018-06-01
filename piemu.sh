#!/bin/sh -exu

dev=$1

kernel_repo=https://raw.githubusercontent.com/dhruvvyas90/qemu-rpi-kernel/master
dtb=versatile-pb.dtb
kernel=kernel-qemu-4.9.59-stretch

mkdir -p .cache
pushd .cache
if ! [[ -f $kernel && -f $dtb ]]; then
  curl --remote-header-name \
   -O $kernel_repo/$kernel \
   -O $kernel_repo/$dtb
fi
ls -lh $kernel $dtb
popd

qemu-system-arm \
  -kernel .cache/$kernel \
  -cpu arm1176 -m 256 -M versatilepb \
  -dtb .cache/$dtb \
  -no-reboot \
  -append "root=${dev}2 rootfstype=ext4 rw console=ttyAMA0" \
  -net nic -net user,hostfwd=tcp::5022-:22 \
  -drive file=$dev,format=raw \
  -nographic
