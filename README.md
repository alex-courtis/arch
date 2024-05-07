# What Is This Repo?

My [dotfiles](http://dotfiles.github.io), managed by [rcm](https://github.com/thoughtbot/rcm), as well as some documentation.

# Documentation

[Arch Installation](doc/arch-install.md)

# Note To Users

If you wish to use these dotfiles, it is advisable to fork this repository. I frequently make large changes that may break your environmont.

# "Desktop Environment"

There is no DE, just a console login which starts a wayland compositor or X11, depending on `$XDG_VTNR`

* [river](https://github.com/riverwm/river) wayland compositor
* [wideriver](https://github.com/riverwm/river) wayland window manager
* [way-displays](https://github.com/alex-courtis/way-displays/) wayland display manager
* [slstatus](https://github.com/alex-courtis/slstatus/) status bar
* [dwm](https://dwm.suckless.org) X window manager
* [xlayoutdisplay](https://github.com/alex-courtis/xlayoutdisplay/) X display manager
* [dual-function-keys](https://gitlab.com/interception/linux/plugins/dual-function-keys)
* [alacritty](https://github.com/alacritty/alacritty) terminal
* [neovim](https://github.com/neovim/neovim) editor
* [rcm](https://github.com/thoughtbot/rcm) dotfile manager
* [zsh](https://github.com/zsh-users/zsh) zsh

# Dotfiles Installation

```sh
git clone git@github.com:alex-courtis/arch.git ~/.dotfiles
RCRC="${HOME}/.dotfiles/rcrc" rcup -v
rcup-root
su -
chsh -s /bin/zsh
ln -s /home/alex/.dotfiles .
RCRC="${HOME}/.dotfiles/rcrc" rcup -v
```

See [rcm](https://github.com/thoughtbot/rcm) for day to day operations.


