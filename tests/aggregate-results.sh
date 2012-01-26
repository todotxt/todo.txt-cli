#!/bin/bash

[ "x$TERM" != "xdumb" ] && (
		export TERM &&
		[ -t 1 ] &&
		tput bold >/dev/null 2>&1 &&
		tput setaf 1 >/dev/null 2>&1 &&
		tput sgr0 >/dev/null 2>&1
	) &&
	color=t

case "$1" in
--no-color)
	color=; shift ;;
esac

if test -n "$color"; then
	say_color () {
		(
		export TERM
		case "$1" in
			error) tput bold; tput setaf 1;; # bold red
			skip)  tput bold; tput setaf 2;; # bold green
			pass)  tput setaf 2;;            # green
			info)  tput setaf 3;;            # brown
			*) test -n "$quiet" && return;;
		esac
		shift
		printf "* %s" "$*"
		tput sgr0
		echo
		)
	}
else
	say_color() {
		test -z "$1" && test -n "$quiet" && return
		shift
		echo "* $*"
	}
fi

get_color()
{
	# Only use the supplied color if there are actually instances of that
	# type, so that a clean test run does not distract the user by the
	# appearance of the error highlighting.
	if [ ${1:?} -eq 0 ]
	then
		echo 'info'
	else
		echo "${2:-info}"
	fi
}


fixed=0
success=0
failed=0
broken=0
total=0

for file
do
	while read type value
	do
		case $type in
		'')
			continue ;;
		fixed)
			fixed=$(($fixed + $value)) ;;
		success)
			success=$(($success + $value)) ;;
		failed)
			failed=$(($failed + $value)) ;;
		broken)
			broken=$(($broken + $value)) ;;
		total)
			total=$(($total + $value)) ;;
		esac
	done <"$file"
done

say_color 'info'                           "$(printf "%-8s%d\n" fixed $fixed)"
say_color "$(get_color "$success" 'pass')" "$(printf "%-8s%d\n" success $success)"
say_color "$(get_color "$failed" 'error')" "$(printf "%-8s%d\n" failed $failed)"
say_color "$(get_color "$broken" 'error')" "$(printf "%-8s%d\n" broken $broken)"
say_color 'info'                           "$(printf "%-8s%d\n" total $total)"
