# This file is part of ranger, the console file manager.
# License: GNU GPL version 3, see the file "AUTHORS" for details.
# Author: Joseph Tannhuber <sepp.tannhuber@yahoo.de>, 2013
# Solarized like colorscheme, similar to solarized-dircolors
# from https://github.com/seebi/dircolors-solarized.
# This is a modification of Roman Zimbelmann's default colorscheme.

from __future__ import (absolute_import, division, print_function)

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    green, cyan, magenta, red, white, blue, black, yellow, default,
    normal, bold, reverse,
    default_colors,
)


class Base16(ColorScheme):
    progress_bar_color = yellow

    def use(self, context):  # pylint: disable=too-many-branches,too-many-statements
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            fg = yellow
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                bg = red
            if context.border:
                fg = default
            if context.media:
                if context.image:
                    fg = magenta
                else:
                    fg = cyan
            if context.container:
                fg = red
            if context.directory:
                fg = blue
            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                fg = green
                attr |= bold
            if context.socket:
                fg = magenta
                bg = 18
                attr |= bold
            if context.fifo:
                fg = yellow
                bg = 18
            if context.device:
                fg = 244
                bg = 18
                attr |= bold
            if context.link:
                fg = cyan if context.good else white
                attr |= bold
                if context.bad:
                    bg = red
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (red, magenta):
                    fg = white
                else:
                    fg = red
            if not context.selected and (context.cut or context.copied):
                fg = 18
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    bg = 237
            if context.badinfo:
                if attr & reverse:
                    bg = magenta
                else:
                    fg = magenta

            if context.inactive_pane:
                fg = 241

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = 16 if context.bad else 255
                if context.bad:
                    bg = 166
            elif context.directory:
                fg = 33
            elif context.tab:
                fg = 47 if context.good else 33
                bg = 239
            elif context.link:
                fg = cyan

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 93
                elif context.bad:
                    fg = 160
                    bg = 235
            if context.marked:
                attr |= bold | reverse
                fg = 237
                bg = 47
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 160
                    bg = 235
            if context.loaded:
                bg = self.progress_bar_color

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 93

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        return fg, bg, attr
