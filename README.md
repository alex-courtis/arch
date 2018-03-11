# Alex's Arch Linux Settings Repository

I use Arch Linux and Xmonad/Xmobar is my desktop environment.

This repository contains system and user configuration files for both laptop and desktop usage.

Also included are instructions for installing Arch from scratch, for a variety of use cases.

## Quick Usage

Clone to somewhere unique e.g. `/opt/alex`

Execute `linkHome.sh` as your user.

Execute `linkSystem.sh` as root. You may need to create some directories if they don't exist or the package has not yet been installed; I'm loathe to allow autocreation of root owned directories so as not to interfere with pacman.

## Arch Installation

Use the standard [Arch installation guide](https://wiki.archlinux.org/index.php/installation_guide) for reference.

### Boot

#### Intel PC

Create a [bootable USB image](https://wiki.archlinux.org/index.php/USB_flash_installation_media)

#### Raspberry PI

* prepare a [Raspberry PI SD card](https://archlinuxarm.org/)
* insert card and boot the device
* ssh or login via console as `alarm/alarm`
* `su - ` with default password `root`
* skip to [Locale And Time](#locale-and-time)

### Wireless Connectivity

You can use `wifi-menu` to connect to a secured network, temporarily.

### Start SSHD for easier installation from a remote system

```
passwd
systemctl start sshd
ip addr
```

Connect from a remote machine

`ssh root@some.ip.address`

### Update the system clock

`timedatectl set-ntp true`

### GPT Partition: ESP Boot and ext4 Root

Find your destination disk with `lsblk -f`

Wipe everything: `wipefs --all /dev/sda`

`parted /dev/sda`

```
mktable GPT
mkpart ESP fat32 1MiB 513MiB
set 1 boot on
name 1 "Arch Boot"
mkpart primary ext4 513MiB 100%
name 2 "Arch Root"
exit
```

### FAT32 Boot and LUKS Encrypted ext4 Root

```
mkfs.vfat  -F32 /dev/sda1
cryptsetup -y -v luksFormat /dev/sda2
cryptsetup open /dev/sda2 cryptroot
mkfs -t ext4 /dev/mapper/cryptroot
```

```
mount -t ext4 /dev/mapper/cryptroot /mnt
mkdir /mnt/boot
mount /dev/sda1  /mnt/boot
```

`lsblk -f` should show something like this:
```
NAME      FSTYPE      LABEL       UUID                                 MOUNTPOINT
loop0     squashfs                                                     /run/archiso/sfs/airootfs
sda                                                                    
├─sda1    vfat                    0526-22BA                            /mnt/boot
└─sda2    crypto_LUKS             9291ea2c-0543-41e1-a0af-e9198b63e0b5 
  └─cryptroot
          ext4                    d64c8087-badc-4fe6-9214-8483d9aa0f96 /mnt
sdb       iso9660     ARCH_201703 2017-03-01-18-21-15-00               
├─sdb1    iso9660     ARCH_201703 2017-03-01-18-21-15-00               /run/archiso/bootmnt
└─sdb2    vfat        ARCHISO_EFI 0F89-08ED
```

### Bootstrap System And Chroot

Edit `/etc/pacman.d/mirrorlist` and put a local one on top

`pacstrap -i /mnt base base-devel`

`genfstab -U /mnt >> /mnt/etc/fstab`

`arch-chroot /mnt /bin/bash`

### Swap File

Create a swap file the same size as physical memory:

```
fallocate -l 8G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap defaults 0 0" >> /etc/fstab
```

### Locale And Time

Uncomment your desired locale in `/etc/locale.gen`

`locale-gen`

`echo LANG=en_AU.UTF-8 > /etc/locale.conf`

`ln -fs /usr/share/zoneinfo/Australia/Sydney /etc/localtime`

`hwclock --systohc --utc`

### Update pacman Packages And Installations To Current

`pacman -Suy`

### Install And Enable Basic Networking

```
pacman -S openssh networkmanager
systemctl enable sshd
systemctl enable NetworkManager
```

### Users

Secure root first with `passwd`

Add a user
```
useradd -m -g users -G wheel,input -c "Alexander Courtis" -s /bin/bash alex
passwd alex
```

`pacman -S vim sudo`

Invoke `visudo` and uncomment the following:

```
%wheel ALL=(ALL) ALL
```

### Intel Microcode

Install Intel microcode updater: `pacman -S intel-ucode`

### systemd boot loader and boot image

`bootctl --path=/boot install`

Edit `/boot/loader/loader.conf` and change its contents to:

```
default arch
timeout 1
```

Determine the UUID of the your crypto_LUKS root volume. Note that it's the raw device, not the crypto volume itself.

`blkid -s UUID -o value /dev/sda2`

Add `/boot/loader/entries/arch.conf`:
```
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=/dev/mapper/cryptroot cryptdevice=/dev/disk/by-uuid/9291ea2c-0543-41e1-a0af-e9198b63e0b5:cryptroot rw
```

If not using encryption, it's best to add an entry for the root partition by UUID instead of device name, as device names are aribtrary. e.g.

```
options root=UUID=86923e75-214e-46ed-98d4-dd15226a67a3 rootfstype=ext4 rw fbcon=scrollback:1024k
```

Add `/boot/loader/entries/arch.fallback.conf` as per `arch.conf` except with the fallback image:
```
initrd /initramfs-linux-fallback.img
```

Update the boot image configuration: `/etc/mkinitcpio.conf`

Add an encrypt hook and move the keyboard configration before it, so that we can type the passphrase. e.g.

```
HOOKS="base udev autodetect modconf block keyboard encrypt filesystems fsck"
```

Regenerate the boot image:

`mkinitcpio -g /boot/initramfs-linux.img`

If the kernel you booted with is a different version to the kernel you just installed, you can achieve the regeneration by reinstalling the later kernel `pacman -S linux`

### Reboot

Install some useful packages prior to reboot, to get you going:

```
pacman -S bash-completion git wget pkgfile
pkgfile --update
```

Exit chroot and reboot

### Remove Default User

Any default users (with known passwords) should be removed e.g.

`userdel -r alarm`

### Set Hostname

Use `nmtui` to setup the system network connection.

Apply the hostname:

`hostnamectl set-hostname duke`

Add the hostname to `/etc/hosts` first, as IPv4 local:

`127.0.0.1	duke`

### Enable NTP Sync

`timedatectl set-ntp true`

You can check this with: `timedatectl status`

### Setup CLI User Environment

Install your public/private keys under `~/.ssh`

Clone this repo to a user available location i.e. `~`

As root, move it to, say, `/opt/alex`

From the end location, link the CLI profile bits:

`./linkHome.sh`

### Video Driver

#### Intel Only (lightweight laptop)

`pacman -S xf86-video-intel`

#### Nvidia Only (desktop)

`pacman -S nvidia`

#### Nvidia + Intel (heavy laptop)

Install both drivers and bumblebee to switch between:

`pacman -S nvidia xf86-video-intel bumblebee`

`systemctl enable bumblebeed.service`

`gpasswd -a alex bumblebee`

You can test switching out as per https://wiki.archlinux.org/index.php/bumblebee#Test

Add a direct invocation of the intel driver in `/etc/X11/xorg.conf.d/20-intel.conf`

This allows the Intel GPU to "take charge" and provide interfaces to standard stuff e.g. xorg-backlight

```
Section "Device"
   Identifier  "Intel Graphics"
   Driver      "intel"
EndSection
```

### Desktop Hibernation

Hibernation is achieved by saving the memory state to the swap file. I do not understand how this works without losing paged out memory.

Find the offset of `/swapfile` on the (encrypted) disk: `filefrag -v /swapfile` and find the first physical offset as per https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#Hibernation_into_swap_file

Add `/boot/loader/entries/arch.conf` `options`: `resume` is the root volume and `resume_offset` is the value derived above e.g.

```
options        root=/dev/mapper/cryptroot resume=/dev/mapper/cryptroot resume_offset=126976 cryptdevice=/dev/disk/by-uuid/2180f899-0705-4b48-bdd4-7d1c8793008d:cryptroot rw`
```

Enable the resume hook in the boot image configuration `/etc/mkinitcpio.conf`, after the encrypt hook e.g.:

`HOOKS="base udev autodetect modconf block keyboard encrypt resume filesystems fsck"`

Regenerate the boot image:

`mkinitcpio -g /boot/initramfs-linux.img`

### Install Packages

I prefer to use [yaourt](https://archlinux.fr/yaourt-en) to manage system and AUR packages.

Install desired packages.

#### Packages I Like

alacritty-git
arandr
calc
dmenu
j4-dmenu-desktop
network-manager-applet
networkmanager-dmenu-git
networkmanager-openconnect
pavucontrol
pinta
pulseaudio-ctl
pwgen
scrot
slock
the_silver_searcher
tmux
ttf-hack
ttf-ms-fonts
udisks2
xautolock
xdg-utils
xdm-archlinux
xmlstarlet
xmobar
xmonad
xmonad-contrib
xorg-fonts-75dpi
xorg-fonts-100dpi
xorg-fonts-misc

#### Laptops Like

libinput-gestures
xf86-input-libinput
xorg-xbacklight

### Install System Configuration

Execute `linkSystem.sh` as root. Any failures due to missing directories should be manually resolved by installing the package or manually creating the directory.

### Regenerate Locales

`locale-gen`

### Enable XDM

`systemctl enable xdm-archlinux`

### Reboot And Start X

Reboot

Login

Everything should start in your X environment... check `/var/log/xdm.log`, `~/.xsession-errors`, `/var/log/Xorg.0.log`, `dmesg --human` and any console errors for oddities.
