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
