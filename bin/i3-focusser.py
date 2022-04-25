#!/usr/bin/env python

# https://www.reddit.com/r/i3wm/comments/95b2hx/alttab_like_behavior/

import i3ipc

last = None


def main():
    i3 = i3ipc.Connection()
    update_focus(i3.get_tree().find_focused())
    i3.on('window::focus', on_focus)
    # Could use ticks but not implemented in latest release of i3ipc-python
    try:
        i3.main()
    finally:
        i3.main_quit()


def on_focus(_, e):
    update_focus(e.container)


def update_focus(container):
    global last
    with open('/tmp/last_focus', 'w') as f:
        print(last, file=f)
    last = container.id


if __name__ == '__main__':
    main()
