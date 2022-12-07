#!/bin/sh

temp=$(sensors | grep -i temp1 | head -n1 | sed -r 's/.*:\s+[\+-]?(.*C)\s+.*/\1/')

usage="$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"

if [ "$usage" -le 9 ]; then
    echo "🖥️  $usage%   $temp"
elif [ "$usage" = 100 ]; then
    echo "🖥️$usage%   $temp"
else
    echo "🖥️ $usage%   $temp"
fi
