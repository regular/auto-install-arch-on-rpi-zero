# alpisd

_Create a bootable SD card containing ArchLinuxArm for a Raspberry Pi (Zero)_

(based on [this gist](https://gist.github.com/4a320f8ee5586fe6170af8051fcd9f85) and [ssh_harden](https://github.com/imsoalan/ssh-harden)

## Features

- starts off with a user-provided rootfs, or downloads the latest release from os.archlinuxarm.org
- changes root password to a random string
- removes default `alarm` user
- creates new user (defaults to the username used when creating the sd card)
- installs sudo, adds new user to group wheel and allows wheel to sudo without password
- sets the new users password to a random string
- transfers your ssh public key to the sd card for passwordless authentication
- hardens ssh configuration (disallow root login, disallow password-based authentication and more)
- sets hostname
- installs additional packages, if desired
- sets up WIFI
- allows you to create a compressed rootfs from the resulting SD card to be used as a base for another run of `alpisd`

The default rootfs image used is good for Raspberry Pi 1 and Zero (armv6).

## Prerequisites

You need to have qemu installed to use this:

`pacman -S qemu qemu-arch-extra expect`

## Configuration

Create a configuration file like this:

``` bash
WIFI_SSID="my ssd"
WIFI_PASSWORD=mypassword
NEW_HOSTNAME=myraspi
NEW_USER=regular # defaults to $(whoami)
SSH_PORT=3000
base_rootfs=path/to/rootfs.tar.gz # defaults to latest from os.archlinuxarm.org
```
## Usage

Make sure that ssh-agent is running and that you addded your ssh id. (for example run `ssh-agent bash` and then `ssh-add`)

Run `./alpisd <sdcard> <path/to/config>`

or, run in order:

- `install-arch-linux-rpi-zero-w.sh <sdcard> <config>`
- `setup-logins.sh <sdcard> <config>`
- `setup-ssh.sh <sdcard> <config>`
- `setup-wifi.sh <sdcard> <config>`
- `setup-hostname.sh <sdcard> <config>`

where <sdcard> is the sd card device node (/dev/sdx for example). Make super sure this is correct, otherwise you might destroy your filesystem!

This takes a while. If you see `*** DONE ***`, it was successful. If you care to see the random passwords, scroll up. You don't really need them though, because you'll be able to login via ssh using your ssh key and then use `sudo passwd` and `sudo passwd $USER` to change the passwords.

You can now put the SD card into your PI and boot from it.

Or you use `make-image.sh <sdcard> <new-rootfs.tar.gz>` to create a gzipped rootfs to be used as a base for another SD card.

## See also/TODO

http://blog.thijsbroenink.com/2015/10/emulate-file-system-with-different-architecture/
http://blog.oddbit.com/2016/02/07/systemd-nspawn-for-fun-and-well-mostly-f/

This could be used to simplify/speed up creation of user acconts (modificarions to passwd/shadow)
