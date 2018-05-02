# Alex's Arch Linux Dotfiles Repository

I use Arch Linux and Xmonad/Xmobar is my desktop environment.

Arch installation instructions and user configuration for desktop, laptop and embedded usage.

![xmonad screenshot](/ss.png?raw=true "xmonad in action!")

## Usage

```
git clone git@github.com:alex-courtis/arch.git ~/.dotfiles
cd ~/.dotfiles
./link.sh
```

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

Wipe everything e.g.
```
wipefs --all /dev/nvme0n1
```

Create partitions e.g.
```
parted /dev/nvme0n1
```
```
mktable GPT
mkpart ESP fat32 1MiB 513MiB
set 1 boot on
name 1 archboot
mkpart primary ext4 513MiB 100%
name 2 archroot
quit
```

### FAT32 Boot and LUKS Encrypted ext4 Root

```
mkfs.vfat -n archboot -F32 /dev/nvme0n1p1
cryptsetup -y -v luksFormat /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 cryptroot
mkfs.ext4 -L archroot /dev/mapper/cryptroot
```

```
mount /dev/mapper/cryptroot /mnt
mkdir /mnt/boot
mount /dev/sda1  /mnt/boot
```

`lsblk -f` should show something like this:
```
NAME        FSTYPE      LABEL       UUID                                 MOUNTPOINT
loop0       squashfs                                                     /run/archiso/sfs/airootfs
nvme0n1                                                                    
├─nvme0n1p1 vfat                    0526-22BA                            /mnt/boot
└─nvme0n1p2 crypto_LUKS             9291ea2c-0543-41e1-a0af-e9198b63e0b5 
  └─cryptroot
            ext4                    d64c8087-badc-4fe6-9214-8483d9aa0f96 /mnt
sda         iso9660     ARCH_201703 2017-03-01-18-21-15-00               
├─sdb1      iso9660     ARCH_201703 2017-03-01-18-21-15-00               /run/archiso/bootmnt
└─sdb2      vfat        ARCHISO_EFI 0F89-08ED
```

### Bootstrap System And Chroot

Edit `/etc/pacman.d/mirrorlist` and put a local one on top

`pacstrap -i /mnt base base-devel`

`genfstab -U /mnt >> /mnt/etc/fstab`

`arch-chroot /mnt /bin/bash`

### Swap File

Create a swap file the same size as physical memory:

```
fallocate -l 16G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap defaults 0 0" >> /etc/fstab
```

### Locale And Time

Uncomment your desired locale in `/etc/locale.gen`. Also `en_US.UTF-8` as too many things expect it :sigh:.

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

```
pacman -S zsh vim sudo
```

Invoke `visudo` and uncomment the following:

```
%wheel ALL=(ALL) ALL
```

Secure root first with `passwd`

Add a user e.g.
```
useradd -m -g users -G wheel,input -c "Alexander Courtis" -s /bin/zsh alex
passwd alex
```

### Intel Microcode

Install Intel CPU microcode updater: `pacman -S intel-ucode`

Not needed for AMD, as they're included in the kernel.

### EFISTUB Preparation

I'm bored with boot loaders and UEFI just doesn't need them. Simply point the EFI boot entry to the ESP, along with the kernel arguments.

Create `/boot/efiBootEntry.sh`:
```
#!/bin/sh

set -e

if [ ${#} -ne 2 ]; then
    echo "usage: ${0} <disk> <partnum, starting at 1>"
    echo "e.g.: ${0} /dev/sda 1"
    exit 1
fi

# cusomise your kernel arguments
KERNEL_ARGS='initrd=\initramfs-linux.img rw quiet'

LOADER='\vmlinuz-linux'
LABEL="Arch Linux"
REGEX_BOOT_ENTRIES="^Boot([[:xdigit:]]*)\* (${LABEL})$"

# print the current table
echo " CURRENT:"
efibootmgr --unicode --verbose
echo

# is there already an entry present?
set +e
EXISTING_ENTRY=$(efibootmgr | grep -E "${REGEX_BOOT_ENTRIES}")
set -e
if [ -n "${EXISTING_ENTRY}" ]; then

    # delete existing
    EXISTING_NUM=$(echo "${EXISTING_ENTRY}" | sed -E "s/${REGEX_BOOT_ENTRIES}/\1/")
    echo " REMOVED ${EXISTING_NUM}:"
    efibootmgr -b "${EXISTING_NUM}" -B --unicode --verbose
    echo
fi

# create the entry
echo " CREATED:"
efibootmgr --create --disk "${1}" --part "${2}" --label "${LABEL}" --loader "${LOADER}" --unicode --verbose "${KERNEL_ARGS}"
echo
```

Determine the UUID of the your crypto_LUKS root volume. Note that it's the raw device, not the crypto volume itself. e.g.

`blkid -s UUID -o value /dev/nvme0n1p2`

Append this to the `KERNEL_ARGS` e.g.:
```
KERNEL_ARGS='initrd=\initramfs-linux.img initrd=\intel-ucode.img root=/dev/mapper/cryptroot cryptdevice=/dev/disk/by-uuid/9291ea2c-0543-41e1-a0af-e9198b63e0b5:cryptroot rw quiet'
```

If using Dell 5520, it's necessary to disable PCIe Active State Power Management as per (https://www.thomas-krenn.com/en/wiki/PCIe_Bus_Error_Status_00001100).

Append to `KERNEL_ARGS`:
```
pcie_aspm=off
```

### Create Boot Image

Update the boot image configuration: `/etc/mkinitcpio.conf`

Add an encrypt hook and move the keyboard configration before it, so that we can type the passphrase.

Add the usr and shutdown hooks so that the root filesystem may be retained during shutdown and cleanly unmounted.

```
HOOKS="base udev autodetect modconf block keyboard encrypt filesystems fsck usr shutdown"
```

(Re)generate the boot image:

`pacman -S linux`

### Create The EFISTUB

```
pacman -S efibootmgr
/boot/efiBootEntry.sh
```

### Reboot

Beforehand, install some useful packages prior to reboot, to get you going:

```
pacman -S git wget pkgfile
pkgfile --update
```

Exit chroot and reboot

### Remove Default User

Any default users (with known passwords) should be removed e.g.

`userdel -r alarm`

### Set Hostname

Use `nmtui` to setup the system network connection.

Apply the hostname e.g.:

`hostnamectl set-hostname gigantor`

Add the hostname to `/etc/hosts` first, as IPv4 local:

`127.0.0.1	gigantor`

### Enable NTP Sync

`timedatectl set-ntp true`

You can check this with: `timedatectl status`

### Setup CLI User Environment

Install your public/private keys under `~/.ssh`

See [Usage](#usage)

### Video Driver

#### Intel Only (lightweight laptop)

`pacman -S xf86-video-intel`

#### Nvidia Only (desktop)

Unfortunately, the nouveau drivers aren't feature complete or performant, so use the dirty, proprietary ones. Linus extends the middle finger to nvidia.

`pacman -S nvidia nvidia-settings`

#### Nvidia + Intel (heavy laptop)

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

### Desktop Hibernation

Hibernation is achieved by saving the memory state to the swap file. I do not understand how this works without losing paged out memory.

Add `resume` and `resume_offset` to `KERNEL_ARGS` in `/boot/efiBootEntry.sh` e.g.
```
resume=/dev/mapper/cryptroot resume_offset=126976
```

`resume` is the root volume.

Find the offset of `/swapfile` on the (encrypted) disk: `filefrag -v /swapfile` and find the first physical offset as per https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#Hibernation_into_swap_file. This is `resume_offset`.

Enable the resume hook in the boot image configuration `/etc/mkinitcpio.conf`, after the encrypt hook e.g.:

`HOOKS="base udev autodetect modconf block keyboard encrypt resume filesystems fsck"`

Regenerate the boot image and the EFI stub:
```
pacman -S linux
/boot/efiBootEntry.sh
```

### Install Packages

I'm liking [aura](https://github.com/aurapm/aura) to manage system and AUR packages.

```
cd /tmp
git clone https://aur.archlinux.org/aura-bin.git
cd aura-bin
makepkg -sri
```

#### Packages I Like

Official:

autofs
calc
chromium
dmenu
efibootmgr
facter
jq
keychain
network-manager-applet
networkmanager-openconnect
nfs-utils
noto-fonts
noto-fonts-emoji
noto-fonts-extra
pavucontrol
pinta
pwgen
scrot
slock
the_silver_searcher
tmux
ttf-hack
udisks2
unzip
xautolock
xdg-utils
xmlstarlet
xmobar
xmonad
xmonad-contrib
xorg-fonts-75dpi
xorg-fonts-100dpi
xorg-fonts-misc
xorg-server
xorg-xsetroot
xterm
xorg-xinit
xorg-xrandr

AUR:

alacritty-git
gron-bin
j4-dmenu-desktop
ncurses5-compat-libs
networkmanager-dmenu-git
pulseaudio-ctl
qdirstat
ttf-ms-fonts
visual-studio-code-bin
xlayoutdisplay

#### Laptops Like

libinput-gestures
xf86-input-libinput
xorg-xbacklight

### Ready To Go

Reboot

Login at TTY1

Everything should start in your X environment... check `~/.local/share/xorg/Xorg.0.log`, `~/.x.log`, `dmesg --human` and any console errors for oddities.
