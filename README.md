# What Is This Repo?

My [dotfiles](http://dotfiles.github.io), managed by [rcm](https://github.com/thoughtbot/rcm), as well as some documentation.

# Documentation

[Arch Top Tips From Alex](doc/arch-tips.md)

[Arch Installation](doc/arch-install.md)

# Note To Users

If you wish to use these dotfiles, it is advisable to fork this repository. I frequently make large changes that may break your environmont.

# "Desktop Environment"

There is no DE, just a console login which starts X11.

[suckless](http://suckless.org/) makes up most of the environment, centred around the [dwm](http://dwm.suckless.org/) window manager.

Configurations:
* [dwm](https://github.com/alex-courtis/dwm/)
* [st](https://github.com/alex-courtis/st/)
* [slstatus](https://github.com/alex-courtis/slstatus/)
* [xlayoutdisplay](https://github.com/alex-courtis/xlayoutdisplay/)

# Dotfiles Installation

```sh
git clone git@github.com:alex-courtis/arch.git ~/.dotfiles
RCRC="${HOME}/.dotfiles/rcrc" rcup -v
```

See [rcm](https://github.com/thoughtbot/rcm) for day to day operations.


