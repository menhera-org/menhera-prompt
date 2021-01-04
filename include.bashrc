
update_prompt () {
	MEM_PERCENT=$(( 100 * $(
		env -i LANG=C free -b | grep -i mem | sed 's/^[^0-9]*\([0-9]*\).*\s\([0-9]\{1,\}\)\s*$/\2 \/ \1/'
	) ))

	which findmnt >/dev/null && {
		CURRENT_MOUNTPOINT=$( findmnt -T "$PWD" | tail -n +2 | awk '{print $1}' )
	} || CURRENT_MOUNTPOINT=/

	DISK_USAGE=$(
		env -i LANG=C df | tail -n +2 | sed 's/.*\s\([0-9]\{1,\}%\)\s*\(.*\)/\1 \2/' | while read disk_info
		do
			mountpoint=${disk_info#* }
			[ "$mountpoint" = "$CURRENT_MOUNTPOINT" ] && echo "${disk_info%% *}"
		done
	)

	PS1="[\D{%H:%M:%S}] \u@\h M:${MEM_PERCENT}%, S:${DISK_USAGE} \[\033[07m\] \W \[\033[00m\] "
	export PS1
}

PROMPT_COMMAND=update_prompt

