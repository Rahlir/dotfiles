#!/bin/sh
# Copyright (C) 2014 Julien Bonjean <julien@bonjean.info>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

if [ "$(uname -s)" != 'Linux' ]; then
    echo "ERROR: memory.sh cannot be run on non-linux kernel"
    exit 1
fi

TYPE="${BLOCK_INSTANCE:-mem}"

awk -v type=$TYPE '
function round(x, ival, aval, fraction)
{
    ival = int(x)
    if (ival == x)
        return ival

    fraction = x - ival
    if (fraction >= .5)
        return ival + 1
    else
        return ival
}
/^MemTotal:/ {
	mem_total=$2
}
/^MemFree:/ {
	mem_free=$2
}
/^Buffers:/ {
	mem_free+=$2
}
/^Cached:/ {
	mem_free+=$2
}
/^SwapTotal:/ {
	swap_total=$2
}
/^SwapFree:/ {
	swap_free=$2
}
END {
	# full text
	if (type == "swap")
		printf("%.1fG\n", (swap_total-swap_free)/1024/1024)
	else
            printf("%.1fG ", (mem_total-mem_free)/1024/1024)
            printf("(%d%%)\n", round((mem_total-mem_free)/mem_total*100))

	# TODO: short text

	# TODO: color (if less than X%)
}
' /proc/meminfo
