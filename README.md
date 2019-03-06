I use Arch Linux and [suckless](http://suckless.org/) is my "desktop environment", using the [dwm](http://dwm.suckless.org/) window manager.

Arch installation instructions and user configuration for desktop, laptop and embedded usage.

My tools/configurations:
* [dwm](https://github.com/alex-courtis/dwm/)
* [slstatus](https://github.com/alex-courtis/slstatus/)
* [xlayoutdisplay](https://github.com/alex-courtis/xlayoutdisplay/)

![xmonad screenshot](/ss.png?raw=true "xmonad in action!")

# Usage

```sh
git clone git@github.com:alex-courtis/arch.git ~/.dotfiles
cd ~/.dotfiles
./link.sh
```

# Arch Top Tips From Alex

## Don't Compress Packages

When invoking makepkg, the results are xz'd by default. This is unnecessary, as they are almost always immediately un-xz'd. Your AUR updates will be _muchly_ faster.

`vi /etc/makepkg.conf`

(yes, I know what I'm doing)

```sh
#########################################################################
# EXTENSION DEFAULTS
#########################################################################
#
# WARNING: Do NOT modify these variables unless you know what you are
#          doing.
#
#PKGEXT='.pkg.tar.xz'
PKGEXT='.pkg.tar'
#SRCEXT='.src.tar.gz'
SRCEXT='.src.tar'
```

## Enable Multi-CPU Compilation

We have multi CPU/thread processors nowadays. Invoke your c compiler with the `-j` option when building packages. Such quick AUR source package updates.

`vi /etc/makepkg.conf`

(my tinygod)

```sh
#########################################################################
# ARCHITECTURE, COMPILE FLAGS
#########################################################################
#
CARCH="x86_64"
CHOST="x86_64-pc-linux-gnu"

#-- Compiler and Linker Flags
CPPFLAGS="-D_FORTIFY_SOURCE=2"
CFLAGS="-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector-strong -fno-plt"
CXXFLAGS="-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector-strong -fno-plt"
LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
#-- Make Flags: change this for DistCC/SMP systems
MAKEFLAGS="-j64"
#-- Debugging flags
DEBUG_CFLAGS="-g -fvar-tracking-assignments"
DEBUG_CXXFLAGS="-g -fvar-tracking-assignments"
```

## Don't Build Fallback Kernel Image

We live on the stable edge in Arch land; I've _never_ had to boot to a "default options" kernel image. Remove it for reduced complexity and a little bit of kernel update speed.

`vi /etc/mkinitcpio.d/linux.preset`

```sh

PRESETS=('default')

```

## Don't Compress Your Kernel Image

In 2018 we have disk space to burn. Don't bother compressing the kernel image.

This doesn't make booting any faster, but it does make new image installation a bit faster.

`vi /etc/mkinitcpio.conf`

```sh
# COMPRESSION
# Use this to compress the initramfs image. By default, gzip compression
# is used. Use 'cat' to create an uncompressed image.
#COMPRESSION="gzip"
#COMPRESSION="bzip2"
#COMPRESSION="lzma"
#COMPRESSION="xz"
#COMPRESSION="lzop"
#COMPRESSION="lz4"
COMPRESSION=cat
```

# Arch Installation

Use the standard [Arch installation guide](https://wiki.archlinux.org/index.php/installation_guide) for reference.

## Boot

### x86_64

Create a [bootable USB image](https://wiki.archlinux.org/index.php/USB_flash_installation_media)

### Raspberry PI ARM

* prepare a [Raspberry PI SD card](https://archlinuxarm.org/)
* insert card and boot the device
* ssh or login via console as `alarm/alarm`
* `su - ` with default password `root`
* skip to [Locale And Time](#locale-and-time)

## Wireless Connectivity

You can use `wifi-menu` to connect to a secured network, temporarily.

## Start SSHD for easier installation from a remote system

```sh
passwd
systemctl start sshd
ip addr
```

Connect from a remote machine

`ssh root@some.ip.address`

## Update the system clock

`timedatectl set-ntp true`

## GPT Partitioning: [LVM on LUKS](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS)

Find your destination disk with `lsblk -f`

Wipe everything e.g.
```sh
wipefs --all /dev/nvme0n1
```

Create partitions e.g.
```sh
parted /dev/nvme0n1
```
```
mktable GPT
mkpart ESP fat32 1MiB 513MiB
set 1 boot on
name 1 boot
mkpart primary 513MiB 100%
name 2 luks
quit
```

## Fat32 Boot

```sh
mkfs.vfat -n boot -F32 /dev/nvme0n1p1
```

## Software RAID

Optional, if multiple devices available.

mdadm --create --verbose --level=0 --metadata=1.2 --raid-devices=2 --homehost=gigantor /dev/md0 /dev/nvme0n1p2 /dev/nvme1n1p2 /dev/nvme2n1p2

Use /dev/md0 as the device for LUKS.

## LVM on LUKS

```sh
cryptsetup luksFormat --type luks2 /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 cryptlvm
pvcreate /dev/mapper/cryptlvm
vgcreate vg1 /dev/mapper/cryptlvm
```

### Swap Volume

Same size as physical RAM.

```sh
lvcreate -L 16G vg1 -n archswap
mkswap /dev/vg1/archswap -L archswap
swapon /dev/vg1/archswap
```

### BTRFS Volume

```sh
lvcreate -l 100%FREE vg1 -n archroot
mkfs.btrfs /dev/vg1/archroot -L archroot
```

## BTRFS Subvolumes

```sh
mount /dev/vg1/archroot /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@docker
umount /mnt
```

## Mount All Filesystems

```sh
mount /dev/vg1/archroot /mnt -o subvol=/@root
mkdir -p /mnt/home /mnt/boot /mnt/var/lib/docker
mount /dev/vg1/archroot /mnt/home -o subvol=/@home
mount /dev/vg1/archroot /mnt/var/lib/docker -o subvol=/@docker
mount /dev/nvme0n1p1 /mnt/boot
```

`lsblk -f` should show something like this:
```
NAME               FSTYPE      LABEL       UUID                                   MOUNTPOINT
loop0              squashfs                                                       /run/archiso/sfs/airootfs
sda                iso9660     ARCH_201805 2018-05-01-05-08-12-00
├─sda1             iso9660     ARCH_201805 2018-05-01-05-08-12-00                 /run/archiso/bootmnt
└─sda2             vfat        ARCHISO_EFI 6116-EC41
nvme0n1
├─nvme0n1p1        vfat        boot        3906-F913                              /mnt/boot
└─nvme0n1p2        crypto_LUKS             b874fabd-ae06-485e-b858-6532cec92d3c
  └─cryptlvm       LVM2_member             k2icwX-dJ1i-lLpk-hBiz-8SP8-dg1X-Fdqh0T
    ├─vg1-archswap swap        archswap    ede007f9-f560-4044-82ca-acf0fbb6824e   [SWAP]
    └─vg1-archroot btrfs       archroot    031a2b85-c701-4f2c-bf32-f86d222391ae   /mnt/var/lib/docker
```

## Bootstrap System

Edit `/etc/pacman.d/mirrorlist` and put a local one on top

`pacstrap -i /mnt base base-devel`

## Setup /etc/fstab

`genfstab -U /mnt >> /mnt/etc/fstab`

Modify `/` for first fsck by setting the last field to 1.

Modify `/home`, `/var/lib/docker` and `/boot` for second fsck by setting to 2.

`/mnt/etc/fstab` should look something like:
```
# /dev/mapper/vg1-archroot LABEL=archroot
UUID=031a2b85-c701-4f2c-bf32-f86d222391ae       /               btrfs           rw,relatime,ssd,space_cache,subvolid=257,subvol=/@root,subvol=@root   0 1

# /dev/mapper/vg1-archroot LABEL=archroot
UUID=031a2b85-c701-4f2c-bf32-f86d222391ae       /home           btrfs           rw,relatime,ssd,space_cache,subvolid=258,subvol=/@home,subvol=@home   0 2

# /dev/mapper/vg1-archroot LABEL=archroot
UUID=031a2b85-c701-4f2c-bf32-f86d222391ae       /var/lib/docker btrfs           rw,relatime,ssd,space_cache,subvolid=259,subvol=/@docker,subvol=@docker       0 2

# /dev/nvme0n1p1 LABEL=boot
UUID=3906-F913          /boot           vfat            rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro     0 2

# /dev/mapper/vg1-archswap LABEL=archswap
UUID=ede007f9-f560-4044-82ca-acf0fbb6824e       none            swap            defaults    0 0
```

## Chroot

`arch-chroot /mnt /bin/bash`

## btrfs filesystem drivers

`pacman -S btrfs-progs`

## Preserve Boot Messages

TTY1 displays system boot messages, however they are cleared by default. Preserve them:

```
mkdir /etc/systemd/system/getty@tty1.service.d
echo "[Service]
TTYVTDisallocate=no" > /etc/systemd/system/getty@tty1.service.d/noclear.conf
```

## Locale And Time

Uncomment your desired locale in `/etc/locale.gen`. Also `en_US.UTF-8` as too many things expect it :sigh:.

`locale-gen`

`echo LANG=en_AU.UTF-8 > /etc/locale.conf`

`ln -fs /usr/share/zoneinfo/Australia/Sydney /etc/localtime`

`hwclock --systohc --utc`

## Update pacman Packages And Installations To Current

`pacman -Suy`

## Install And Enable Basic Networking

```sh
pacman -S openssh networkmanager
systemctl enable sshd
systemctl enable NetworkManager
```

## Users

```sh
pacman -S zsh vim sudo
```

Link vi to vim:
```sh
ln -s /usr/bin/vim /usr/local/bin/vi
ln -s /usr/bin/vim /usr/local/bin/view
```

Invoke `visudo` and uncomment the following:

```sh
%wheel ALL=(ALL) ALL
```

Secure root first with `passwd`

Add a user e.g.
```sh
useradd -m -g users -G wheel,input -c "Alexander Courtis" -s /bin/zsh alex
passwd alex
```

## EFISTUB Preparation

I'm bored with boot loaders and UEFI just doesn't need them. Simply point the EFI boot entry to the ESP, along with the kernel arguments.

Copy `bin/efibootstub` from this repository into `/usr/local/bin`

Determine the UUID of the your crypto_LUKS volume. Note that it's the raw device, not the crypto volume itself. e.g.

`blkid -s UUID -o value /dev/nvme0n1p2`

Create kernel command line in `/boot/kargs` e.g.
```
initrd=\initramfs-linux.img cryptdevice=UUID=b874fabd-ae06-485e-b858-6532cec92d3c:cryptlvm root=/dev/vg1/archroot rootflags=subvol=/@root resume=/dev/vg1/archswap rw quiet
```

If using Dell 5520, it's necessary to disable PCIe Active State Power Management as per (https://www.thomas-krenn.com/en/wiki/PCIe_Bus_Error_Status_00001100).

Append to `/boot/kargs`:
```
pcie_aspm=off
```

## Create initrd and kernel

Update the boot image configuration: `/etc/mkinitcpio.conf`

Add an encrypt hook and move the keyboard configration before it, so that we can type the passphrase.

Add lvm2 before filessystems so that we may open the volumes.

Add resume hook after filesystems.

Add usr and shutdown hooks so that the root filesystem may be retained during shutdown and cleanly unmounted.

If using software raid, add mdadm_udev before encrypt.

```sh
HOOKS=(base udev autodetect modconf block keyboard mdadm_udev encrypt lvm2 filesystems resume fsck usr shutdown)
```

(Re)generate the boot image:

`pacman -S linux`

## AMD CPU Microcode

Install AMD CPU microcode updater: `pacman -S amd-ucode`

Prepend `initrd=\amd-ucode.img ` to `/boot/kargs`.

## Intel CPU Microcode

Install Intel CPU microcode updater: `pacman -S intel-ucode`

Prepend `initrd=\intel-ucode.img ` to `/boot/kargs`.

## Create The EFISTUB

```sh
pacman -S efibootmgr
efibootstub /dev/nvme0n1 1
```

### Alternative: systemd-boot

Some terribad UEFI implementations such as Dell 5520 don't want to boot directly from UEFI; they only seem to support booting from an .efi file, hence we use systemd-boot.

```sh
bootctl --path=/boot install
```

Edit `/boot/loader/loader.conf` and change its contents to:
```
default arch
timeout 1
```

Add `/boot/loader/entries/arch.conf`, using `/boot/kargs` for options, with initrd moved up:

```
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options cryptdevice=UUID=b874fabd-ae06-485e-b858-6532cec92d3c:cryptlvm root=/dev/vg1/archroot rootflags=subvol=/@root resume=/dev/vg1/archswap pcie_aspm=off rw
```

## Reboot

First, install some useful packages to get you going:

```sh
pacman -S git wget pkgfile
pkgfile --update
```

Exit chroot and reboot

## Remove Default User

Any default users (with known passwords) should be removed e.g.

`userdel -r alarm`

## Set Hostname

Use `nmtui` to setup the system network connection.

Apply the hostname e.g.:

`hostnamectl set-hostname gigantor`

Add the hostname to `/etc/hosts` first, as IPv4 local:

`127.0.0.1	gigantor`

## Enable NTP Sync

`timedatectl set-ntp true`

You can check this with: `timedatectl status`

## Setup CLI User Environment

Install your public/private keys under `~/.ssh`

See [Usage](#usage)

## Video Driver

### Modern AMD

Add `amdgpu` to MODULES in `/etc/mkinitcpio.conf`

Install the X driver and (re)generate the boot image:

`pacman -S xf86-video-amdgpu linux`

### Intel Only (lightweight laptop)

`pacman -S xf86-video-intel`

### Nvidia Only (desktop)

Unfortunately, the nouveau drivers aren't feature complete or performant, so use the dirty, proprietary ones. Linus extends the middle finger to nvidia.

`pacman -S nvidia nvidia-settings`

### Nvidia + Intel (heavy laptop)

I don't need the nvidia discrete GPU for a work laptop, so completely disable it.

If the discrete GPU is needed, optimus/prime may be used to enable it on demand.

`pacman -S xf86-video-intel bbswitch`

Load the bbswitch module via `/etc/modules-load.d/bbswitch.conf`:

```
bbswitch
```

Disable/enable the GPU on module load/unload via `/etc/modprobe.d/bbswitch.conf`:

```
options bbswitch load_state=0 unload_state=1
```

Ban the nouveau module, which can block bbswitch, via `/etc/modprobe.d/blacklisted.conf`:

```
blacklist nouveau
```

## Install Packages

I'm liking [aura](https://github.com/aurapm/aura) to manage system and AUR packages.

```sh
cd /tmp
git clone https://aur.archlinux.org/aura-bin.git
cd aura-bin
makepkg -sri
```

### Packages I Like

#### Official

`pacman -S ...`

alacritty
autofs
calc
chromium
dex
dmenu
docker
dunst
efibootmgr
facter
jq
keychain
network-manager-applet
nfs-utils
noto-fonts
noto-fonts-emoji
noto-fonts-extra
pasystray
pavucontrol
pwgen
rsync
scrot
slock
sysstat
the_silver_searcher
tmux
ttf-dejavu
ttf-hack
udisks2
unzip
xautolock
xdg-utils
xmlstarlet
xorg-fonts-100dpi
xorg-fonts-75dpi
xorg-fonts-misc
xorg-server
xorg-xinit
xorg-xrandr
xterm
zsh-completions

#### AUR

`aura -Ax ...`

gron-bin
j4-dmenu-desktop
qdirstat
pulseaudio-ctl
redshift-minimal
ttf-ms-fonts
xlayoutdisplay

### Laptops Like

xf86-input-libinput
libinput-gestures
xorg-xbacklight

## Build Desktop Environment

Clone the following:
* [dwm](https://github.com/alex-courtis/dwm/)
* [slstatus](https://github.com/alex-courtis/slstatus/)

Run for each:
`make && sudo make install`


## Ready To Go

Reboot

Login at TTY1

Everything should start in your X environment... check `~/.local/share/xorg/Xorg.0.log`, `~/.x.log`, `dmesg --human` and any console errors for oddities.
