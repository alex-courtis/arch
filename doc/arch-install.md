# Arch Installation

This is very much the copy and paste guide to installation.

Use the standard [Arch installation guide](https://wiki.archlinux.org/index.php/installation_guide) for reference.

<!-- markdown-toc -i arch-install.md -->

<!-- toc -->

- [Preparation](#preparation)
  * [Boot](#boot)
  * [Keymap](#keymap)
  * [SSHD](#sshd)
- [Disks](#disks)
  * [Partitions](#partitions)
  * [Filesystems](#filesystems)
    + [Swap](#swap)
    + [Root](#root)
    + [Boot](#boot-1)
    + [Docker](#docker)
    + [Home](#home)
- [Installation](#installation)
  * [Bootstrap](#bootstrap)
  * [Setup /etc/fstab](#setup-etcfstab)
  * [Chroot](#chroot)
  * [Basic Packages](#basic-packages)
  * [Pacman Config](#pacman-config)
  * [Locale And Time](#locale-and-time)
  * [Networking](#networking)
  * [Virtual Console](#virtual-console)
  * [Microcode](#microcode)
  * [SSD Trimming](#ssd-trimming)
- [Users](#users)
- [Tweaks](#tweaks)
- [Booting](#booting)
  * [Create Boot Image](#create-boot-image)
  * [systemd-boot](#systemd-boot)
  * [Reboot](#reboot)
- [Post Install](#post-install)
  * [Set Hostname](#set-hostname)
  * [Enable NTP Sync](#enable-ntp-sync)
  * [yay Package Manager](#yay-package-manager)
  * [Install Packages](#install-packages)
  * [CLI User Environment](#cli-user-environment)
  * [Disable systemd-userdbd](#disable-systemd-userdbd)
  * [Done](#done)
- [Firmware](#firmware)
  * [Intel Audio](#intel-audio)
- [Audio](#audio)
- [Video](#video)
  * [AMD](#amd)
  * [Intel](#intel)

<!-- tocstop -->

## Preparation

### Boot

Boot a [bootable USB image](https://wiki.archlinux.org/index.php/USB_flash_installation_media)

You can use [iwctl](https://wiki.archlinux.org/index.php/Iwd#iwctl) to connect to a secured network, temporarily.

### Keymap

```sh
loadkeys dvorak-programmer
```

### SSHD

Root passwd:
```sh
passwd
```

sshd should already be started:
```sh
systemctl start sshd
ip addr
```

## Disks

### Partitions

Find your destination disk:
```sh
lsblk -f
```

Wipe everything:
```sh
wipefs --all /dev/nvme0n1
```

Create partitions, with swap size matching physical RAM:
```sh
parted /dev/nvme0n1
```
```
unit GiB
mktable GPT
mkpart ESP fat32 1MiB 1GiB
set 1 boot on
mkpart swap linux-swap 1GiB 65GiB
mkpart root 65GiB 20%
mkpart docker 20% 30%
mkpart home 30% 100%
quit
```

### Filesystems

#### Swap

```sh
mkswap /dev/nvme0n1p2 -L swap
swapon /dev/nvme0n1p2
```

#### Root

```sh
mkfs.ext4 /dev/nvme0n1p3 -L root
mount /dev/nvme0n1p3 /mnt
```

#### Boot

```sh
mkfs.vfat -n boot -F32 /dev/nvme0n1p1
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

#### Docker

```sh
mkfs.ext4 /dev/nvme0n1p4 -L docker
mkdir -p /mnt/var/lib/docker
mount /dev/nvme0n1p4 /mnt/var/lib/docker
```

#### Home
```sh
mkfs.ext4 /dev/nvme0n1p5 -L home
mkdir /mnt/home
mount /dev/nvme0n1p5 /mnt/home
```

## Installation

### Bootstrap

Put a local mirror on top:
```sh
vim /etc/pacman.d/mirrorlist
```

Bootstrap:
```sh
pacstrap -i /mnt base base-devel linux linux-firmware
```

### Setup /etc/fstab

```sh
genfstab -U /mnt >> /mnt/etc/fstab
vim /mnt/etc/fstab
```

Modify `/` for first fsck by setting the last field to 1.

Modify `/boot` for second fsck by setting to 2.

Secure `/boot` `fmask=0077,dmask=0077`

### Chroot

```sh
arch-chroot /mnt
set -o vi
alias vi=vim
```

### Basic Packages

```sh
pacman -S efibootmgr git vim mkinitcpio networkmanager openssh pkgfile sudo zsh
```

### Pacman Config

Setup better defaults:
```sh
vi /etc/pacman.conf`
```
```
Color
ParallelDownloads = 10
```

Tell makepkg not to (xz) compress packages:
```sh
vi /etc/makepkg.conf`
```
```
PKGEXT='.pkg.tar'
SRCEXT='.src.tar'
```

### Locale And Time

Set your desired UTF8 locale. Also `en_US`, as many things expect it:
```sh
vi /etc/locale.gen
```

Generate and set locale:
```sh
locale-gen
echo LANG=en_AU.UTF-8 > /etc/locale.conf
```

Time:
```sh
ln -fs /usr/share/zoneinfo/Australia/Sydney /etc/localtime
hwclock --systohc --utc
```

### Networking

```sh
systemctl enable sshd
systemctl enable NetworkManager
```

### Virtual Console

Keymap:
```sh
vi /etc/vconsole.conf
```
```
KEYMAP=dvorak-programmer
```

### Microcode

Install the CPU microcode for amd or intel:
```sh
pacman -S amd-ucode
```

### SSD Trimming

Run ~once weekly for all devices that support it. See `fstrim --fstab --dry-run`
```sh
systemctl enable fstrim.timer
```

## Users

sudo secure defaults:
```
visudo
```
```
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
%wheel ALL=(ALL) ALL
```

Secure root:
```sh
passwd
```

Root shell:
```sh
chsh -s /usr/bin/zsh
```

Add a user:
```sh
useradd -m -g users -G wheel,input -c "Alexander Courtis" -s /bin/zsh alex
passwd alex
```

## Tweaks

[Arch Top Tips From Alex](arch-tips.md).

## Booting

### Create Boot Image

Remove fallback image:
```sh
vi /etc/mkinitcpio.d/linux.preset
```
```
PRESETS=('default')
```

Update the boot image configuration:
```sh
vi /etc/mkinitcpio.conf
```

Add hooks. It's fine to use multiple lines, which makes for easier change detection.
```
HOOKS=(
    base
    udev
    autodetect
    microcode
    modconf
    kms
    keyboard
    keymap
    block
    filesystems
    fsck
    resume
)
```

Don't compress the image or modules.
```
COMPRESSION=cat
MODULES_DECOMPRESS="yes"
```

(Re)generate the boot image:

```sh
rm /boot/initramfs*
pacman -S linux
```

### systemd-boot

Install:
```sh
bootctl --path=/boot install
```

Link:
```sh
vi /boot/loader/loader.conf
```
```
timeout 2
default Arch Linux
```

Try `console-mode max` to use native resolution.

Entry
```sh
cat << EOF > /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=UUID=
 resume=UUID=
 rw

EOF
```

Inject the UUIDs of the root and swap partitions:
```sh
blkid -s UUID -o value /dev/nvme0n1p3 >> /boot/loader/entries/arch.conf
blkid -s UUID -o value /dev/nvme0n1p2 >> /boot/loader/entries/arch.conf
```
Move them into their correct places: root and resume.

### Reboot

Cleanly reboot:
```sh
exit
swapoff /dev/nvme0n1p2
umount /mnt/var/lib/docker
umount /mnt/home
umount /mnt/boot
umount /mnt
sync
reboot
```

## Post Install

Log in as yourself.

### Set Hostname

Use `sudo nmtui` to setup the system network connection.

Apply the hostname e.g.:

```sh
hostnamectl set-hostname gigantor
```

Add the localhosts to `/etc/hosts` first:

```
127.0.0.1 localhost
::1       localhost
```

### Enable NTP Sync

```sh
timedatectl set-ntp true
```

You can check this with:
```sh
timedatectl status
```

### yay Package Manager

[yay](https://github.com/Jguer/yay)

```sh
cd /tmp
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -sri
```

### Install Packages

AUR packages are at the end.

`yay -S
alacritty
bemenu-wayland
bluez
blueman
brave-bin
calc
dmenu
dnsutils
efibootmgr
gpm
hunspell-en_AU
hunspell-en_GB
fd
fwupd
fzf
grim
inetutils
interception-dual-function-keys
inter-font
jq
keychain
libva-utils
man-db
man-pages
neovim
nm-connection-editor
nfs-utils
noto-fonts
noto-fonts-emoji
noto-fonts-extra
pacman-contrib
pavucontrol
pulseaudio
pwgen
ripgrep
rsync
scrot
slock
slurp
sqlite3
swappy
swayidle
swaylock
sysstat
terminus-font
ttf-dejavu
ttf-hack-nerd
ttf-inter
udisks2
usbutils
unzip
vdpauinfo
wl-clipboard
xautolock
xdg-desktop-portal-wlr
xdg-utils
xmlstarlet
xorg-fonts-100dpi
xorg-fonts-75dpi
xorg-fonts-misc
xorg-server
xorg-xbacklight
xorg-xinit
xorg-xrandr
xsel
zsh-completions
go-yq
htop-vim
lemonade-git
libinput-gestures
lswt
menjar
nerd-fonts-hack
rcm
river-git
rivercarro
todotxt
way-displays
wev
xlayoutdisplay
ydotool
zig-static
zsh-system-clipboard-git
`

Clean any unnecessary packages:
```sh
yay -Rns $(yay -Qdtq)
```

### CLI User Environment

Install your public/private keys into `~/.ssh`, from a remote machine:
```sh
scp -pr .ssh gigantor:/home/alex
```

User:
```sh
git clone git@github.com:alex-courtis/arch.git ~/.dotfiles
RCRC="${HOME}/.dotfiles/rcrc" rcup -v

ln -fs /usr/bin/nvim ~/bin/vi
```

Root:
```sh
ln -s /home/alex/.dotfiles
RCRC="${HOME}/.dotfiles/rcrc" rcup -v

ln -fs /usr/bin/nvim ~/bin/vi

ln -s /home/alex/.ssh .
```

### Disable systemd-userdbd

This was [recently added](https://gitlab.archlinux.org/archlinux/packaging/packages/systemd/-/commit/8545926672960dc46a51d03baa8263f5a16faa44) and of questionable value. Remove it.

```sh
systemctl disable systemd-userdbd.socket
systemctl stop systemd-userdbd.socket
systemctl disable systemd-userdbd.service
systemctl stop systemd-userdbd.service
```

### Done

Log in via tty1

## Firmware

### Intel Audio

```sh
lspci | grep "Intel Corporation Comet Lake PCH-LP cAVS"
```

Firmware:
```sh
yay -S sof-firmware
```

## Audio

Enable pulseaudio:
```sh
systemctl enable --user pulseaudio
```

Add user to the audio group to allow alsa access to sound devices when headless. Not recommended for security reasons.
```sh
sudo usermod -a -G audio alex
```

## Video

Test that hardware acceleration is available via `vainfo` and `vdpauinfo`.

### AMD

Add amdgpu module:
```sh
vi /etc/mkinitcpio.conf
```

Install the X, va, vdpau and vulkan drivers and (re)generate the boot image:
```sh
yay -S xf86-video-amdgpu libva-mesa-driver mesa-vdpau vulkan-radeon linux
```

Ensure the performant RADV vulkan implementation is used rather than the slower AMDVLK:
```sh
vulkaninfo | grep "^GPU "
```

vdpau test needs to know the driver:
```sh
VDPAU_DRIVER=radeonsi vdpauinfo
```

Blacklist:
```sh
cat << EOF > /etc/modprobe.d/no_ucsi_ccg.conf
# nvidia specific usb c
blacklist ucsi_ccg
EOF
```

### Intel

KMS will automatically be used.

```sh
yay -S xf86-video-intel libva-intel-driver intel-media-driver
```
