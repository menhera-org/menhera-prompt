
update_prompt () {
	local status=$?
	[ "$status" ] || status=0

	#local MEM_PERCENT
	#MEM_PERCENT=$(( 100 - 100 * $(
	#	env -i LANG=C free -b | grep -i mem | sed 's/^[^0-9]*\([0-9]*\).*\s\([0-9]\{1,\}\)\s*$/\2 \/ \1/'
	#) ))

	local CURRENT_MOUNTPOINT
	which findmnt >/dev/null && {
		CURRENT_MOUNTPOINT=$( findmnt -T "$PWD" | tail -n +2 | awk '{print $1}' )
	} || CURRENT_MOUNTPOINT=/

	local DISK_USAGE
	DISK_USAGE=$(
		env -i LANG=C df | tail -n +2 | sed 's/.*\s\([0-9]\{1,\}%\)\s*\(.*\)/\1 \2/' | while read disk_info
		do
			mountpoint=${disk_info#* }
			[ "$mountpoint" = "$CURRENT_MOUNTPOINT" ] && echo "${disk_info%% *}"
		done
	)
	
	PS1="\007\[\033[07m\]\D{%H:%M:%S} \W:${DISK_USAGE}"
	[ $status -eq 0 ] && {
		PS1="${PS1}\[\033[00m\]\[\033[42;39m\]\[\033[42;37m\]\u\$\[\033[49;32m\]\[\033[00m\] "
	} || {
		PS1="${PS1}\[\033[00m\]\[\033[41;39m\]\[\033[41;37m\]\u\$\[\033[49;31m\]\[\033[00m\] "
	}

	export PS1
}

PROMPT_COMMAND=update_prompt

