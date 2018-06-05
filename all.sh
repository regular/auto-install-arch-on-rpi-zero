#!/bin/sh -exu

echo "\n*** Installing base system ***"
if [ $# -gt 1 ] ; then
  ./install-arch-linux-rpi-zero-w.sh $1 $2
else
  ./install-arch-linux-rpi-zero-w.sh $1
fi

echo "\n*** Setting up logins ***"
./setup-logins.sh $1
echo "\n*** Hardening ssh ***"
./setup-ssh.sh $1
echo "\n*** Setting up WIFI ***"
./setup-wifi.sh $1
echo "\n*** Setting hostname ***"
./setup-hostname.sh $1
echo "\n*** Done ***"
