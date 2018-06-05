#!/bin/sh -exu
./install-arch-linux-rpi-zero-w.sh $1
echo "*** Setting up logins ***"
./setup-logins.sh $1
echo "*** Hardening ssh ***"
./setup-ssh.sh $1
echo "*** Setting up WIFI ***"
./setup-wifi.sh $1
./setup-hostname.sh $1
echo "*** Done ***"
