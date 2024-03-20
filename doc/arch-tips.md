# Arch Top Tips From Alex

## Pacman UX Tweaks

`vi /etc/pacman.conf`

```
Color
ParallelDownloads = 10
```

## Don't Compress Packages

When invoking makepkg, the results are xz'd by default. This is unnecessary, as they are almost always immediately un-xz'd. Your AUR updates will be _muchly_ faster.

`vi /etc/makepkg.conf`

(yes, I know what I'm doing)

```sh
PKGEXT='.pkg.tar'
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
COMPRESSION=cat
MODULES_DECOMPRESS="yes"
```
