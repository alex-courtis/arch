# base16-qutebrowser (https://github.com/theova/base16-qutebrowser)
# Scheme name: Bright
# Scheme author: Chris Kempson (http://chriskempson.com)
# Template author: theova and Daniel Mulford
# Commentary: Tinted Theming: (https://github.com/tinted-theming)

import os

default_background =   '#' + os.environ['BASE16_default_background']
lighter_background =   '#' + os.environ['BASE16_lighter_background']
selection_background = '#' + os.environ['BASE16_selection_background']
comments =             '#' + os.environ['BASE16_comments']
# dark_foreground =      '#' + os.environ['BASE16_dark_foreground']
default_foreground =   '#' + os.environ['BASE16_default_foreground']
light_foreground =     '#' + os.environ['BASE16_light_foreground']
# light_background =     '#' + os.environ['BASE16_light_background']
red =                  '#' + os.environ['BASE16_red']
orange =               '#' + os.environ['BASE16_orange']
yellow =               '#' + os.environ['BASE16_yellow']
# green =                '#' + os.environ['BASE16_green']
cyan =                 '#' + os.environ['BASE16_cyan']
blue =                 '#' + os.environ['BASE16_blue']
magenta =              '#' + os.environ['BASE16_magenta']
brown =                '#' + os.environ['BASE16_brown']

# set qutebrowser colors

# Text color of the completion widget. May be a single color to use for
# all columns or a list of three colors, one for each column.
c.colors.completion.fg = default_foreground

# Background color of the completion widget for odd rows.
c.colors.completion.odd.bg = lighter_background

# Background color of the completion widget for even rows.
c.colors.completion.even.bg = lighter_background

# Foreground color of completion widget category headers.
c.colors.completion.category.fg = blue

# Background color of the completion widget category headers.
c.colors.completion.category.bg = lighter_background

# Top border color of the completion widget category headers.
c.colors.completion.category.border.top = lighter_background

# Bottom border color of the completion widget category headers.
c.colors.completion.category.border.bottom = lighter_background

# Foreground color of the selected completion item.
c.colors.completion.item.selected.fg = default_foreground

# Background color of the selected completion item.
c.colors.completion.item.selected.bg = selection_background

# Top border color of the selected completion item.
c.colors.completion.item.selected.border.top = selection_background

# Bottom border color of the selected completion item.
c.colors.completion.item.selected.border.bottom = selection_background

# Foreground color of the matched text in the selected completion item.
c.colors.completion.item.selected.match.fg = default_foreground

# Foreground color of the matched text in the completion.
c.colors.completion.match.fg = orange

# Color of the scrollbar handle in the completion view.
c.colors.completion.scrollbar.fg = default_foreground

# Color of the scrollbar in the completion view.
c.colors.completion.scrollbar.bg = selection_background

# Background color of disabled items in the context menu.
# c.colors.contextmenu.disabled.bg = lighter_background

# Foreground color of disabled items in the context menu.
# c.colors.contextmenu.disabled.fg = dark_foreground

# Background color of the context menu. If set to null, the Qt default is used.
# c.colors.contextmenu.menu.bg = default_background

# Foreground color of the context menu. If set to null, the Qt default is used.
# c.colors.contextmenu.menu.fg =  default_foreground

# Background color of the context menu’s selected item. If set to null, the Qt default is used.
# c.colors.contextmenu.selected.bg = selection_background

#Foreground color of the context menu’s selected item. If set to null, the Qt default is used.
# c.colors.contextmenu.selected.fg = default_foreground

# Background color for the download bar.
c.colors.downloads.bar.bg = lighter_background

# Color gradient start for download text.
c.colors.downloads.start.fg = blue

# Color gradient start for download backgrounds.
c.colors.downloads.start.bg = blue

# Color gradient end for download text.
c.colors.downloads.stop.fg = green

# Color gradient stop for download backgrounds.
c.colors.downloads.stop.bg = green

# Foreground color for downloads with errors.
c.colors.downloads.error.fg = red

# Font color for hints.
c.colors.hints.fg = default_background

# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
c.colors.hints.bg = yellow

# Font color for the matched part of hints.
c.colors.hints.match.fg = brown

# Text color for the keyhint widget.
c.colors.keyhint.fg = default_foreground

# Highlight color for keys to complete the current keychain.
c.colors.keyhint.suffix.fg = orange

# Background color of the keyhint widget.
c.colors.keyhint.bg = lighter_background

# Foreground color of an error message.
c.colors.messages.error.fg = default_background

# Background color of an error message.
c.colors.messages.error.bg = red

# Border color of an error message.
c.colors.messages.error.border = red

# Foreground color of a warning message.
c.colors.messages.warning.fg = default_background

# Background color of a warning message.
c.colors.messages.warning.bg = magenta

# Border color of a warning message.
c.colors.messages.warning.border = magenta

# Foreground color of an info message.
c.colors.messages.info.fg = default_background

# Background color of an info message.
c.colors.messages.info.bg = cyan

# Border color of an info message.
c.colors.messages.info.border = cyan

# Foreground color for prompts.
c.colors.prompts.fg = default_foreground

# Border used around UI elements in prompts.
c.colors.prompts.border = lighter_background

# Background color for prompts.
c.colors.prompts.bg = lighter_background

# Background color for the selected item in filename prompts.
c.colors.prompts.selected.bg = selection_background

# Foreground color for the selected item in filename prompts.
c.colors.prompts.selected.fg = orange

# Foreground color of the statusbar.
c.colors.statusbar.normal.fg = default_foreground

# Background color of the statusbar.
c.colors.statusbar.normal.bg = lighter_background

# Foreground color of the statusbar in insert mode.
c.colors.statusbar.insert.fg = default_background

# Background color of the statusbar in insert mode.
c.colors.statusbar.insert.bg = blue

# Foreground color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.fg = default_background

# Background color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.bg = yellow

# Foreground color of the statusbar in private browsing mode.
c.colors.statusbar.private.fg = default_background

# Background color of the statusbar in private browsing mode.
c.colors.statusbar.private.bg = brown

# Foreground color of the statusbar in command mode.
c.colors.statusbar.command.fg = default_foreground

# Background color of the statusbar in command mode.
c.colors.statusbar.command.bg = selection_background

# Foreground color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.fg = brown

# Background color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.bg = selection_background

# Foreground color of the statusbar in caret mode.
c.colors.statusbar.caret.fg = default_background

# Background color of the statusbar in caret mode.
c.colors.statusbar.caret.bg = magenta

# Foreground color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.fg = default_background

# Background color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.bg = magenta

# Background color of the progress bar.
c.colors.statusbar.progress.bg = blue

# Default foreground color of the URL in the statusbar.
c.colors.statusbar.url.fg = default_foreground

# Foreground color of the URL in the statusbar on error.
c.colors.statusbar.url.error.fg = red

# Foreground color of the URL in the statusbar for hovered links.
c.colors.statusbar.url.hover.fg = orange

# Foreground color of the URL in the statusbar on successful load
# (http).
c.colors.statusbar.url.success.http.fg = comments

# Foreground color of the URL in the statusbar on successful load
# (https).
c.colors.statusbar.url.success.https.fg = comments

# Foreground color of the URL in the statusbar when there's a warning.
c.colors.statusbar.url.warn.fg = magenta

# Background color of the tab bar.
c.colors.tabs.bar.bg = default_background

# Color gradient start for the tab indicator.
c.colors.tabs.indicator.start = blue

# Color gradient end for the tab indicator.
c.colors.tabs.indicator.stop = default_foreground

# Color for the tab indicator on errors.
c.colors.tabs.indicator.error = red

# Foreground color of unselected odd tabs.
c.colors.tabs.odd.fg = default_foreground

# Background color of unselected odd tabs.
c.colors.tabs.odd.bg = lighter_background

# Foreground color of unselected even tabs.
c.colors.tabs.even.fg = default_foreground

# Background color of unselected even tabs.
c.colors.tabs.even.bg = lighter_background

# Background color of pinned unselected even tabs.
c.colors.tabs.pinned.even.bg = default_background

# Foreground color of pinned unselected even tabs.
c.colors.tabs.pinned.even.fg = default_foreground

# Background color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.bg = default_background

# Foreground color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.fg = default_foreground

# Background color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.bg = selection_background

# Foreground color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.fg = default_foreground

# Background color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.bg = selection_background

# Foreground color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.fg = default_foreground

# Foreground color of selected odd tabs.
c.colors.tabs.selected.odd.fg = default_foreground

# Background color of selected odd tabs.
c.colors.tabs.selected.odd.bg = selection_background

# Foreground color of selected even tabs.
c.colors.tabs.selected.even.fg = default_foreground

# Background color of selected even tabs.
c.colors.tabs.selected.even.bg = selection_background

# Background color for webpages if unset (or empty to use the theme's
# color).
# c.colors.webpage.bg = lighter_background
