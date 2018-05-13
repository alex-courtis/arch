I use Arch Linux and Xmonad/Xmobar is my desktop environment.

Arch installation instructions and user configuration for desktop, laptop and embedded usage.

![xmonad screenshot](/ss.png?raw=true "xmonad in action!")

# Usage

```sh
git clone git@github.com:alex-courtis/arch.git ~/.dotfiles
cd ~/.dotfiles
./link.sh
```

# Arch Installation

Use the standard [Arch installation guide](https://wiki.archlinux.org/index.php/installation_guide) for reference.

## Boot

### Intel PC

Create a [bootable USB image](https://wiki.archlinux.org/index.php/USB_flash_installation_media)

### Raspberry PI

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

## GPT Partitions: ESP Boot and LUKS

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

## Filesystem: FAT32 Boot

```sh
mkfs.vfat -n boot -F32 /dev/nvme0n1p1
```

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
mkswap /dev/vg1/archswap -L archswapbtrfs
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
umount /mnt
```

## Mount All Filesystems

```sh
mount /dev/vg1/archroot /mnt -o subvol=@root
mkdir /mnt/home /mnt/boot
mount /dev/vg1/archroot /mnt/home -o subvol=@home
mount /dev/nvme0n1p1 /mnt/boot
```

`lsblk -f` should show something like this:
```
NAME                FSTYPE      LABEL       UUID                                   MOUNTPOINT
loop0               squashfs                                                       /run/archiso/sfs/airootfs
sda                 iso9660     ARCH_201805 2018-05-01-05-08-12-00
├─sda1              iso9660     ARCH_201805 2018-05-01-05-08-12-00                 /run/archiso/bootmnt
└─sda2              vfat        ARCHISO_EFI 6116-EC41
nvme0n1
├─nvme0n1p1         vfat        boot        070C-46E6                              /mnt/boot
└─nvme0n1p2         crypto_LUKS             f92f75a8-995d-428d-bf72-6a1fc7d482e5
  └─cryptlvm        LVM2_member             DsgNGR-oSKb-yBD4-EDvd-RhGq-8abB-PRTzbc
    ├─vg1-archswap  swap        archswap    beeb009e-bf7b-4026-81a2-fd4bbb2e82f9   [SWAP]
    └─vg1-archroot  btrfs       archroot    4a90fabc-7e40-446d-b507-1bdad61f93b6   /mnt/home
```

## Bootstrap System

Edit `/etc/pacman.d/mirrorlist` and put a local one on top

`pacstrap -i /mnt base base-devel`

## Setup /etc/fstab

`genfstab -U /mnt >> /mnt/etc/fstab`

Modify / for first fsck by setting the last field to 1.

Modify /home and /boot for second fsck by setting to 2.

`/mnt/etc/fstab` should look something like:
```
# Static information about the filesystems.
# See fstab(5) for details.

# <file system> <dir> <type> <options> <dump> <pass>
# /dev/mapper/vg1-archroot LABEL=archroot
UUID=4a90fabc-7e40-446d-b507-1bdad61f93b6       /               btrfs           rw,relatime,ssd,space_cache,subvolid=257,subvol=/@root,subvol=
@root   0 1

# /dev/mapper/vg1-archroot LABEL=archroot
UUID=4a90fabc-7e40-446d-b507-1bdad61f93b6       /home           btrfs           rw,relatime,ssd,space_cache,subvolid=258,subvol=/@home,subvol=
@home   0 2

# /dev/nvme0n1p1 LABEL=boot
UUID=070C-46E6          /boot           vfat            rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,utf
8,errors=remount-ro     0 2

# /dev/mapper/vg1-archswap LABEL=archswap
UUID=beeb009e-bf7b-4026-81a2-fd4bbb2e82f9       none            swap            defaults,pri=-2 0 0
```

## Chroot

`arch-chroot /mnt /bin/bash`

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

Copy `bin/efiBootStub` from this repository into `/usr/local/bin`

Determine the UUID of the your crypto_LUKS root volume. Note that it's the raw device, not the crypto volume itself. e.g.

`blkid -s UUID -o value /dev/nvme0n1p2`

Create kernel command line in `/boot/kargs` e.g.
```
initrd=\initramfs-linux.img cryptdevice=UUID=f92f75a8-995d-428d-bf72-6a1fc7d482e5:cryptlvm root=/dev/vg1/archroot rootflags=subvol=/@root resume=/dev/vg1/archswap rw quiet
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

```sh
HOOKS=(base udev autodetect modconf block keyboard encrypt lvm2 filesystems resume fsck usr shutdown)
```

(Re)generate the boot image:

`pacman -S linux`

## Intel Microcode

Install Intel CPU microcode updater: `pacman -S intel-ucode`

Not needed for AMD, as they're included in the kernel.

Prepend `initrd=\intel-ucode.img ` to `/boot/kargs`.

## Create The EFISTUB

```sh
pacman -S efibootmgr
efiBootStub /dev/nvme0n1 1
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

### Intel Only (lightweight laptop)

`pacman -S xf86-video-intel`

### Nvidia Only (desktop)

Unfortunately, the nouveau drivers aren't feature complete or performant, so use the dirty, proprietary ones. Linus extends the middle finger to nvidia.

`pacman -S nvidia nvidia-settings`

### Nvidia + Intel (heavy laptop)

I don't need the nvidia discrete GPU for a work laptop, so completely disable it.

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

Alternatively, if the discrete GPU is needed, optimus/prime may be used to enable it on demand.

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

autofs
calc
chromium
dmenu
docker
efibootmgr
facter
jq
keychain
network-manager-applet
nfs-utils
noto-fonts
noto-fonts-emoji
noto-fonts-extra
pavucontrol
pwgen
qdirstat
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
xmobar
xmonad
xmonad-contrib
xorg-fonts-100dpi
xorg-fonts-75dpi
xorg-fonts-misc
xorg-server
xorg-xinit
xorg-xrandr
xorg-xsetroot
xterm
zsh-completions

#### AUR

`aura -Ax ...`

alacritty-git
gron-bin
j4-dmenu-desktop
ncurses5-compat-libs
networkmanager-dmenu-git
pulseaudio-ctl
ttf-ms-fonts
xlayoutdisplay

### Laptops Like

libinput-gestures
xf86-input-libinput
xorg-xbacklight

## Ready To Go

Reboot

Login at TTY1

Everything should start in your X environment... check `~/.local/share/xorg/Xorg.0.log`, `~/.x.log`, `dmesg --human` and any console errors for oddities.
