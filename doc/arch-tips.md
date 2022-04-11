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
