# What Is This Repo?

My [dotfiles](http://dotfiles.github.io), managed by [rcm](https://github.com/thoughtbot/rcm), as well as some documentation.

# Documentation

[Arch Top Tips From Alex](doc/arch-tips.md)

[Arch Installation](doc/arch-install.md)

# Note To Users

If you wish to use these dotfiles, it is advisable to fork this repository. I frequently make large changes that may break your environmont.

# "Desktop Environment"

There is no DE, just a console login which starts sway or X11, depending on `$XDG_VTNR`

* [slstatus](https://github.com/alex-courtis/slstatus/)

## 1 - sway

* [way-displays](https://github.com/alex-courtis/way-displays/)

## 2 - i3

When only an nvidia card is available.

* [xlayoutdisplay](https://github.com/alex-courtis/xlayoutdisplay/)

# Dotfiles Installation

```sh
git clone git@github.com:alex-courtis/arch.git ~/.dotfiles
RCRC="${HOME}/.dotfiles/rcrc" rcup -v
rcup-root
su -
ln -s /home/alex/.dotfiles .
RCRC="${HOME}/.dotfiles/rcrc" rcup -v
```

See [rcm](https://github.com/thoughtbot/rcm) for day to day operations.


