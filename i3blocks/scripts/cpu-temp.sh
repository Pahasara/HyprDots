#!/bin/sh
echo "$(sensors | grep 'Package id 0:\|Tdie' | grep ':[ ]*+[0-9]*.[0-9]*°C' -o | grep '+[0-9]*.[0-9]*°C' -o)" | awk '{ printf("%6s\n"), $1 }'
