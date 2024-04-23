# Arch Installation

This is very much the copy and paste guide to installation.

Use the standard [Arch installation guide](https://wiki.archlinux.org/index.php/installation_guide) for reference.

## Preparation

### Boot

Boot a [bootable USB image](https://wiki.archlinux.org/index.php/USB_flash_installation_media)

You can use [iwctl](https://wiki.archlinux.org/index.php/Iwd#iwctl) to connect to a secured network, temporarily.

### Keymap

```sh
loadkeys dvorak-programmer
```

### Start SSHD for easier installation from a remote system

```sh
passwd
systemctl start sshd
ip addr
```
Connect from a remote machine

```sh
ssh root@some.ip.address
```

## Filesystems

### Partitions

Find your destination disk:

```sh
lsblk -f
```

Wipe everything
```sh
wipefs --all /dev/nvme0n1
```

Create partitions, with swap size matching physical RAM
```sh
parted /dev/nvme0n1
```
```
mktable GPT
mkpart ESP fat32 1MiB 513MiB
set 1 boot on
name 1 boot
mkpart primary 513MiB 33281MiB
name 2 swap
mkpart primary 33281MiB 100%
name 3 root
quit
```

### Fat32 Boot

```sh
mkfs.vfat -n boot -F32 /dev/nvme0n1p1
```

### Swap

```sh
mkswap /dev/nvme0n1p2 -L swap
swapon /dev/nvme0n1p2
```

### Root Filesystem

```sh
mkfs.ext4 /dev/nvme0n1p3 -L root
mount /dev/nvme0n1p3 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

## Installation

### Bootstrap

Edit `/etc/pacman.d/mirrorlist` and put a local one on top

```sh
pacstrap -i /mnt base base-devel linux linux-firmware
```

### Setup /etc/fstab

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

Modify `/` for first fsck by setting the last field to 1.

Modify `/boot` for second fsck by setting to 2.

### Chroot

```sh
arch-chroot /mnt /bin/bash
```

### Packages Needed For Installation

```sh
pacman -S efibootmgr git vim mkinitcpio networkmanager openssh pkgfile sudo zsh
```

### Locale And Time

Uncomment your desired UTF8 locale in `/etc/locale.gen`. Also `en_US` as too many things expect it :sigh:.

```sh
locale-gen
```

```sh
echo LANG=en_AU.UTF-8 > /etc/locale.conf
```

```sh
ln -fs /usr/share/zoneinfo/Australia/Sydney /etc/localtime
```

```sh
hwclock --systohc --utc
```

### Update Packages And Installations To Current

```sh
pacman -Suy
```

### Install And Enable Basic Networking

```sh
systemctl enable sshd
systemctl enable NetworkManager
```

### Virtual Console Configuration

Add the following to `/etc/vconsole.conf`
```
KEYMAP=dvorak-programmer
```

### Microcode

Install the CPU microcode for amd or intel:
```sh
pacman -S amd-ucode
```

## Users

Invoke `visudo` and uncomment the following:

```sh
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
%wheel ALL=(ALL) ALL
```

Secure root first with `passwd`

Add a user e.g.
```sh
useradd -m -g users -G wheel,input -c "Alexander Courtis" -s /bin/zsh alex
passwd alex
```

## Tweaks

[Arch Top Tips From Alex](arch-tips.md).

## Booting

### Create Boot Image

Update the boot image configuration: `/etc/mkinitcpio.conf`

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

(Re)generate the boot image:

```sh
rm /boot/initramfs*
pacman -S linux
```

### systemd-boot

```sh
bootctl --path=/boot install
```

Edit `/boot/loader/loader.conf` and change its contents to:
```
timeout 2
default Arch Linux
```

Try `console-mode max` to use native resolution.

Create `/boot/loader/entries/arch.conf`:
```
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=UUID=
 resume=UUID=
 rootflags=subvol=/@root rw quiet


```
Change amd to intel as needed.

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
umount /mnt/home
umount /mnt/boot
umount /mnt
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

### Install [yay](https://github.com/Jguer/yay)

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
autofs
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
thunderbird
ttf-dejavu
ttf-hack-nerd
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

Install [Audio Drivers](https://github.com/alex-courtis/arch/blob/master/doc/arch-install.md#audio-drivers) and [Video Drivers](https://github.com/alex-courtis/arch/blob/master/doc/arch-install.md#video-drivers) this point.

### Setup CLI User Environment

Install your public/private keys into `~/.ssh`, from a remote machine:
```sh
scp -pr .ssh gigantor:/home/alex
```

```sh
git clone git@github.com:alex-courtis/arch.git ~/.dotfiles
RCRC="${HOME}/.dotfiles/rcrc" rcup -v
```

### Done

Everything should start in your X environment... check `~/.local/share/xorg/Xorg.0.log`, `/tmp/i3.x.${XDG_VTNR}.${USER}.log`, `/tmp/sway.${XDG_VTNR}.${USER}.log`, `dmesg --human` and any console errors for oddities.

## USB Firmware

`WARNING: Possibly missing firmware for module: xxx` during kernel image build indicates missing firmware.

```sh
yay -S upd72020x-fw
yay -S ast-firmware
```

See [Possibly_missing_firmware_for_module_XXXX](https://wiki.archlinux.org/title/Mkinitcpio#Possibly_missing_firmware_for_module_XXXX)

## Audio Drivers

Enable pulseaudio:
```sh
systemctl enable --user pulseaudio
```

Add user to the audio group to allow alsa access to sound devices when headless. Not recommended for security reasons.
```sh
sudo usermod -a -G audio alex
```

### Intel Corporation Comet Lake PCH-LP cAVS

```sh
lspci | grep "Intel Corporation Comet Lake PCH-LP cAVS"
```

Firmware:
```sh
yay -S sof-firmware
```

## Video Drivers

Test that hardware acceleration is available via `vainfo` and `vdpauinfo`.

### Modern AMD

Add `amdgpu` to MODULES in `/etc/mkinitcpio.conf`

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

Create `/etc/modprobe.d/no_ucsi_ccg.conf`
```
# nvidia specific usb c
blacklist ucsi_ccg
```

### Intel Only (lightweight laptop)

KMS will automatically be used.

```sh
yay -S xf86-video-intel libva-intel-driver intel-media-driver
```

### Nvidia Only (desktop)

Unfortunately, the nouveau drivers aren't feature complete or performant, so use the dirty, proprietary ones. Linus extends the middle finger to nvidia.

```sh
yay -S nvidia libva-vdpau-driver libva-vdpau-driver-chromium
```

### Nvidia + Intel (heavy laptop)

#### Switching GPUs

[Optimus](https://wiki.archlinux.org/index.php/NVIDIA_Optimus) [Prime](https://wiki.archlinux.org/index.php/PRIME) will switch between the integrated Intel GPU and the discrete Nvidia one.

The discrete one will only be used automagically on demand when, say, launching a game.

If the magic doesn't happen, use `prime-run` to launch the app.

```sh
yay -S xf86-video-intel libva-intel-driver nvidia nvidia-prime
```

#### Turn Off Nvidia GPU

Install `bbswitch`.

Create `/etc/modprobe.d/bbswitch.conf`:

```
blacklist nouveau
options bbswitch load_state=0 unload_state=1
```

Create `/etc/modules-load.d/bbswitch.conf`:

```sh
bbswitch
```

Rebuild initramfs and reboot.
