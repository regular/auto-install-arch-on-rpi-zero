#!/bin/sh -exu

dev=$1
pidfile=$2

qemu-system-arm \
  -kernel $HOME/Downloads/kernel-qemu-4.9.59-stretch \
  -cpu arm1176 -m 256 -M versatilepb \
  -dtb $HOME/Downloads/versatile-pb.dtb \
  -no-reboot \
  -append "root=${dev}2 rootfstype=ext4 rw console=ttyAMA0" \
  -net nic -net user,hostfwd=tcp::5022-:22 \
  -drive file=$dev,format=raw \
  -pidfile $pidfile \
  -serial stdio

  #-runas regular \
