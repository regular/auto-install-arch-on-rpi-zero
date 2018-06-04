## Create the SD Card

(based on [this gist](https://gist.github.com/4a320f8ee5586fe6170af8051fcd9f85))


# Prerequisites

`pacman -S qemu qemu-arch-extra expect`


Create a file called  `config`:

``` bash
WIFI_SSID="my ssd"
WIFI_PASSWORD=mypassword
NEW_USER=regular # defaults to $(whoami)
SSH_COPY_ID=1 # transfer public key for passwprdless login
```

## Qemu

Users are added and removed in a qemu environment.

Then run in order:

- `install-arch-linux-rpi-zero-w.sh <sdcard>`
- `setup-logins.sh <sdcard>`
- `setup-wifi.sh <sdcard>`

## See also

http://blog.thijsbroenink.com/2015/10/emulate-file-system-with-different-architecture/
http://blog.oddbit.com/2016/02/07/systemd-nspawn-for-fun-and-well-mostly-f/

This could be used to simplify/speed up creation of user acconts (modificarions to passwd/shadow)



