# What Is This Repo?

My [dotfiles](http://dotfiles.github.io), managed by [rcm](https://github.com/thoughtbot/rcm).

Documentation for a smooth [Arch Linux](https://www.archlinux.org/) installation for a variety of use cases including desktop, laptop and embedded.

Also some Arch Linux to make your life easier.

# Note To Users

If you wish to use these dotfiles, it is advisable to fork this repository. I frequently make large changes that may break your environmont.

# "Desktop Environment"

There is no DE, just a console login which starts X11.

[suckless](http://suckless.org/) makes up most of the environment, centred around the [dwm](http://dwm.suckless.org/) window manager.

Configurations:
* [dwm](https://github.com/alex-courtis/dwm/)
* [slstatus](https://github.com/alex-courtis/slstatus/)
* [xlayoutdisplay](https://github.com/alex-courtis/xlayoutdisplay/)

# Install

```sh
git clone git@github.com:alex-courtis/arch.git ~/.dotfiles
RCRC="${HOME}/.dotfiles/rcrc" rcup -v
```

See [rcm](https://github.com/thoughtbot/rcm) for day to day operations.

# Documentation

## [Arch Top Tips From Alex](doc/arch-tips.md)

## [Arch Installation](doc/arch-install.md)

