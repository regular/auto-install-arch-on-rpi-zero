## Create the SD Card

(based on [this gist](https://gist.github.com/4a320f8ee5586fe6170af8051fcd9f85) and [ssh_harden](https://github.com/imsoalan/ssh-harden)

# Prerequisites

`pacman -S qemu qemu-arch-extra expect`

Create a file called  `config`:

``` bash
WIFI_SSID="my ssd"
WIFI_PASSWORD=mypassword
NEW_HOSTNAME=myraspi
NEW_USER=regular # defaults to $(whoami)
SSH_COPY_ID=1 # TODO transfer public key for passwprdless login
SSH_PORT=3000
```

Then run `./all.sh <sdcard>`

or, run in order:

- `install-arch-linux-rpi-zero-w.sh <sdcard>`
- `setup-logins.sh <sdcard>`
- `setup-ssh.sh <sdcard>`
- `setup-wifi.sh <sdcard>`
- `setup-hostname.sh <sdcard>`

where <sdcard> is the sd card device node (/dev/sdx for example). Make super sure this is correct, otherwise you might destroy your filesystem!

## See also

http://blog.thijsbroenink.com/2015/10/emulate-file-system-with-different-architecture/
http://blog.oddbit.com/2016/02/07/systemd-nspawn-for-fun-and-well-mostly-f/

This could be used to simplify/speed up creation of user acconts (modificarions to passwd/shadow)



