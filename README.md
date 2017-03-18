# Alex's Arch Linux Settings Repository

### Quick Usage

Clone to somewhere unique e.g. `/opt/alex`.

Execute `linkHome.sh` as your user.

Execute `linkSystem.sh` as root. You may need to create some directories if they don't exist or the package has not yet been installed; I'm loathe to allow autocreation of root owned directories so as not to interfere with pacman.

# Arch Installation

Use the standard [Arch installation guide](https://wiki.archlinux.org/index.php/installation_guide) for reference.

## Wireless Connectivity

You can use `wifi-menu` to connect to a secured network, temporarily.

## Start SSHD for easier installation from a remote system

```
passwd
systemctl start sshd
ip addr
```

Connect from a remote machine

`ssh root@some.ip.address`

## Update the system clock

`timedatectl set-ntp true`

## Partition An EFI Boot and Root

Find your destination disk with `lsblk -f`

Wipe everything: `wipefs --all /dev/sda`

`parted /dev/sda`

```
mktable GPT
mkpart ESP fat32 1MiB 513MiB
set 1 boot on
mkpart primary ext4 513MiB 100%
```

## Create FAT32 Boot and LUKS Encrypted EXT4 Root

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

## Bootstrap System And Chroot

Edit `/etc/pacman.d/mirrorlist` and put a local one on top

`pacstrap -i /mnt base base-devel`

`genfstab -U /mnt >> /mnt/etc/fstab`

`arch-chroot /mnt /bin/bash`

## Swap File

Create a swap file the same size as physical memory:

```
fallocate -l 8G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap defaults 0 0" >> /etc/fstab
```

## Locale And Time

Uncomment your desired locale in `/etc/locale.gen`

`locale-gen`

`echo LANG=en_AU.UTF-8 > /etc/locale.conf`

`ln -fs /usr/share/zoneinfo/Australia/Sydney /etc/localtime`

`hwclock --systohc --utc`

## Install And Enable Basic Networking

```
pacman -S openssh networkmanager
systemctl enable sshd
systemctl enable NetworkManager
```

## Users

Secure root first with `passwd`

Add a user
```
useradd -m -g users -G wheel input -c "Alexander Courtis" -s /bin/bash alex
passwd alex
```

`pacman -S vim`

Invoke `visudo` and uncomment the following:

```
%wheel ALL=(ALL) ALL
```

## systemd boot loader

Install Intel microcode updater: `pacman -S intel-ucode`

`bootctl --path=/boot install`

Edit `/boot/loader/loader.conf` and change its contents to:

```
default arch
```

Determine the UUID of the your crypto_LUKS root volume. Note that it's the raw device, not the crypto volume itself.

`blkid -s UUID -o value /dev/sda2`

Add `/boot/loader/entries/arch.conf`:
```
title          Arch Linux
linux          /vmlinuz-linux
initrd         /intel-ucode.img
initrd         /initramfs-linux.img
options        root=/dev/mapper/cryptroot cryptdevice=/dev/disk/by-uuid/9291ea2c-0543-41e1-a0af-e9198b63e0b5:cryptroot rw
```

## Boot Image

Update the boot image configuration: `/etc/mkinitcpio.conf`

If you have an Intel i915 display, add it:

```
MODULES="i915"
```

Add an encrypt hook and move the keyboard configration before it, so that we can type the passphrase:

```
HOOKS="base udev autodetect modconf block keyboard encrypt filesystems fsck"
```

Regenerate the boot image:

`mkinitcpio -g /boot/initramfs-linux.img`

If the kernel you booted with is a different version to the kernel you just installed, you can achieve the regeneration by reinstalling the later kernel `pacman -S linux`

## Reboot

Install some useful packages prior to reboot, to get you going:

```
pacman -S bash-completion git wget pkgfile
pkgfile --update
```

Exit chroot and reboot

## Set Hostname

Use `nmtui` to setup the system network connection.

Apply the hostname:

`hostnamectl set-hostname duke`

## Setup CLI User Environment

Install your public/private keys under `~/.ssh`

Clone this repo to, say, `/opt/alex`, ensuring the ownership of that directory and its children is the user.

Link the CLI profile bits:

`./linkHome.sh`

## Install Packages

I prefer to use [yaourt](https://archlinux.fr/yaourt-en) to manage system and AUR packages.

Remove netctl: `pacman -R netctl`

Install desired packages.

Some packages I like, in no particular order.

[ttf-ms-win10](https://aur.archlinux.org/packages/ttf-ms-win10/) - needs manual install

google-chrome
j4-dmenu-desktop
jdk
libinput-gestures
networkmanager-dmenu-git
rxvt-unicode-better-wheel-scrolling
arandr
calc
dmenu
i3lock
network-manager-applet
networkmanager-openconnect
pavucontrol
pinta
pulseaudio-ctl
pwgen
scrot
the_silver_searcher
ttf-hack
xautolock
xdm-archlinux
xf86-input-libinput
xmlstarlet
xmobar
xmonad
xmonad-contrib
xorg-server
xorg-xbacklight
xorg-xrandr
xorg-xrdb

## Install System Configuration

Execute `linkSystem.sh` as root. Any failures due to missing directories should be manually resolved by installing the package or manually creating the directory.

## Enable XDM And Reboot

`sudo systemctl enable xdm-archlinux`

Reboot

Everything should be ready to go... check `dmesg --human` and `~/.xsession-errors` for any oddities.

# Non-UEFI Differences

For systems that are not happy with UEFI e.g. gigabyte, you can use GRUB and a single root partition.

## Partition An EFI Boot and Root

Find your destination disk with `lsblk -f`

Wipe everything: `wipefs --all /dev/sda`

`parted /dev/sda`

```
mktable GPT
mkpart primary ext4 1MiB 100%
```

## Create LUKS Encrypted EXT4 Root

```
cryptsetup -y -v luksFormat /dev/sda1
cryptsetup open /dev/sda1 cryptroot
mkfs -t ext4 /dev/mapper/cryptroot
```

```
mount -t ext4 /dev/mapper/cryptroot /mnt
```

`lsblk -f` should show something like this:
```
NAME          FSTYPE LABEL UUID                                 MOUNTPOINT
loop0         squash                                            /run/archi
sda                                                             
└─sda1        crypto       52d5fc1b-d0ca-46e3-95f4-1b07992ae755 
  └─cryptroot ext4         554fa13c-c55b-41dd-9ed2-dfcf49822dec /mnt
sdb           iso966 ARCH_201703
│                          2017-03-01-18-21-15-00               
├─sdb1        iso966 ARCH_201703
│                          2017-03-01-18-21-15-00               /run/archi
└─sdb2        vfat   ARCHISO_EFI
                           0F89-08ED
```
