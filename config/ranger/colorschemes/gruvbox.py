# This file is part of ranger, the console file manager.
# License: GNU GPL version 3, see the file "AUTHORS" for details.

from __future__ import (absolute_import, division, print_function)

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    black, blue, cyan, green, magenta, red, white, yellow, default,
    normal, bold, reverse, dim, BRIGHT,
    default_colors,
)

GRUV_DARK0 = 235
GRUV_DARK1 = 237
GRUV_DARK2 = 239
GRUV_DARK3 = 241
GRUV_DARK4 = 243
GRUV_GRAY = 245

GRUV_RED = 124
GRUV_GREEN = 106
GRUV_YELLOW = 172
GRUV_BLUE = 66
GRUV_PURPLE = 132
GRUV_AQUA = 72
GRUV_ORANGE = 166

GRUV_RED_BRIGHT = 167
GRUV_GREEN_BRIGHT = 142
GRUV_YELLOW_BRIGHT = 214
GRUV_BLUE_BRIGHT = 109
GRUV_PURPLE_BRIGHT = 175
GRUV_AQUA_BRIGHT = 108
GRUV_ORANGE_BRIGHT = 208

GRUV_LIGHT1 = 223
GRUV_LIGHT2 = 250
GRUV_LIGHT3 = 248
GRUV_LIGHT4 = 246


class Gruvbox(ColorScheme):
    progress_bar_color = GRUV_YELLOW

    def use(self, context):  # pylint: disable=too-many-branches,too-many-statements
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            fg = GRUV_YELLOW
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                bg = GRUV_RED
            if context.border:
                fg = GRUV_DARK2
            if context.media:
                if context.image:
                    fg = GRUV_YELLOW
                else:
                    fg = GRUV_PURPLE
            if context.container:
                fg = GRUV_RED
            if context.directory:
                attr |= bold
                fg = GRUV_BLUE
            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                attr |= bold
                fg = GRUV_GREEN_BRIGHT
            if context.socket:
                attr |= bold
                fg = GRUV_PURPLE_BRIGHT
            if context.fifo or context.device:
                fg = GRUV_YELLOW
                if context.device:
                    attr |= bold
            if context.link:
                fg = GRUV_AQUA if context.good else GRUV_PURPLE
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (GRUV_RED, GRUV_PURPLE):
                    fg = GRUV_LIGHT1
                else:
                    fg = GRUV_RED_BRIGHT
            if not context.selected and (context.cut or context.copied):
                attr |= bold
                fg = GRUV_DARK0
                # If the terminal doesn't support bright colors, use dim white
                # instead of black.
                if BRIGHT == 0:
                    attr |= dim
                    fg = GRUV_LIGHT4
            if context.main_column:
                # Doubling up with BRIGHT here causes issues because it's
                # additive not idempotent.
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    bg = GRUV_DARK2
            if context.badinfo:
                if attr & reverse:
                    bg = GRUV_PURPLE
                else:
                    fg = GRUV_PURPLE

            if context.inactive_pane:
                fg = GRUV_AQUA

        elif context.in_titlebar:
            bg = GRUV_DARK2
            if context.hostname:
                fg = GRUV_RED_BRIGHT if context.bad else GRUV_ORANGE_BRIGHT
            elif context.directory:
                fg = GRUV_AQUA
            elif context.tab:
                if context.good:
                    fg = GRUV_RED
                    bg = GRUV_LIGHT1
            elif context.link:
                fg = GRUV_AQUA_BRIGHT
            attr |= bold

        elif context.in_statusbar:
            bg = GRUV_DARK1
            fg = GRUV_LIGHT2
            if context.permissions:
                if context.good:
                    fg = GRUV_LIGHT4
                elif context.bad:
                    fg = GRUV_PURPLE
            if context.marked:
                attr |= bold | reverse
                fg = GRUV_GREEN_BRIGHT
            if context.frozen:
                attr |= bold | reverse
                fg = GRUV_AQUA_BRIGHT
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = GRUV_RED_BRIGHT
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = GRUV_BLUE
                attr &= ~bold
            if context.vcscommit:
                fg = GRUV_YELLOW
                attr &= ~bold
            if context.vcsdate:
                fg = GRUV_AQUA
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = GRUV_BLUE

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = GRUV_PURPLE
            elif context.vcsuntracked:
                fg = GRUV_AQUA
            elif context.vcschanged:
                fg = GRUV_RED
            elif context.vcsunknown:
                fg = GRUV_RED
            elif context.vcsstaged:
                fg = GRUV_GREEN
            elif context.vcssync:
                fg = GRUV_GREEN
            elif context.vcsignored:
                fg = default

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync or context.vcsnone:
                fg = GRUV_GREEN
            elif context.vcsbehind:
                fg = GRUV_RED
            elif context.vcsahead:
                fg = GRUV_BLUE
            elif context.vcsdiverged:
                fg = GRUV_PURPLE
            elif context.vcsunknown:
                fg = GRUV_RED

        return fg, bg, attr
