#!/bin/sh

[ "$1" ] && pid=$1 || pid=$PPID


mem=$(( 100 - 100 * $(
	LANG=C free -b | grep -i mem | sed 's/^[^0-9]*\([0-9]*\).*\s\([0-9]\{1,\}\)\s*$/\2 \/ \1/'
) ))

SSH=$( ps -o cmd --ppid "${pid}" | tail -n +2 | egrep '(^|/)ssh' ) 2>/dev/null
[ "$SSH" ] && host=${SSH##* } || host=${USER}@$(hostname)

echo "Mem:${mem}% ${host}"

