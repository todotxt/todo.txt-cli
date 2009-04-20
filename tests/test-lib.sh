#!/bin/sh
#
# Copyright (c) 2005 Junio C Hamano
#

# if --tee was passed, write the output not only to the terminal, but
# additionally to the file test-results/$BASENAME.out, too.
case "$TEST_TEE_STARTED, $* " in
done,*)
	# do not redirect again
	;;
*' --tee '*|*' --va'*)
	mkdir -p test-results
	BASE=test-results/$(basename "$0" .sh)
	(TEST_TEE_STARTED=done ${SHELL-sh} "$0" "$@" 2>&1;
	 echo $? > $BASE.exit) | tee $BASE.out
	test "$(cat $BASE.exit)" = 0
	exit
	;;
esac

# Keep the original TERM for say_color
ORIGINAL_TERM=$TERM

# For repeatability, reset the environment to known value.
LANG=C
LC_ALL=C
PAGER=cat
TZ=UTC
TERM=dumb
export LANG LC_ALL PAGER TERM TZ
EDITOR=:
VISUAL=:

# Protect ourselves from common misconfiguration to export
# CDPATH into the environment
unset CDPATH

# Protect ourselves from using predefined TODOTXT_CFG_FILE
unset TODOTXT_CFG_FILE $(set|sed '/^TODOTXT_/!d;s/=.*//')
# To prevent any damage if someone has still those exported somehow in his env:
unset TODO_FILE DONE_FILE REPORT_FILE TMP_FILE

# Each test should start with something like this, after copyright notices:
#
# test_description='Description of this test...
# This test checks if command xyzzy does the right thing...
# '
# . ./test-lib.sh
[ "x$ORIGINAL_TERM" != "xdumb" ] && (
		TERM=$ORIGINAL_TERM &&
		export TERM &&
		[ -t 1 ] &&
		tput bold >/dev/null 2>&1 &&
		tput setaf 1 >/dev/null 2>&1 &&
		tput sgr0 >/dev/null 2>&1
	) &&
	color=t

while test "$#" -ne 0
do
	case "$1" in
	-d|--d|--de|--deb|--debu|--debug)
		debug=t; shift ;;
	-i|--i|--im|--imm|--imme|--immed|--immedi|--immedia|--immediat|--immediate)
		immediate=t; shift ;;
	-l|--l|--lo|--lon|--long|--long-|--long-t|--long-te|--long-tes|--long-test|--long-tests)
		TODOTXT_TEST_LONG=t; export TODOTXT_TEST_LONG; shift ;;
	-h|--h|--he|--hel|--help)
		help=t; shift ;;
	-v|--v|--ve|--ver|--verb|--verbo|--verbos|--verbose)
		verbose=t; shift ;;
	-q|--q|--qu|--qui|--quie|--quiet)
		quiet=t; shift ;;
	--no-color)
		color=; shift ;;
	--no-python)
		# noop now...
		shift ;;
	--tee)
		shift ;; # was handled already
	*)
		break ;;
	esac
done

if test -n "$color"; then
	say_color () {
		(
		TERM=$ORIGINAL_TERM
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

error () {
	say_color error "error: $*"
	trap - EXIT
	exit 1
}

say () {
	say_color info "$*"
}

test "${test_description}" != "" ||
error "Test script did not set test_description."

if test "$help" = "t"
then
	echo "$test_description"
	exit 0
fi

exec 5>&1
if test "$verbose" = "t"
then
	exec 4>&2 3>&1
else
	exec 4>/dev/null 3>/dev/null
fi

test_failure=0
test_count=0
test_fixed=0
test_broken=0
test_success=0

die () {
	echo >&5 "FATAL: Unexpected exit with code $?"
	exit 1
}

trap 'die' EXIT

# The semantics of the editor variables are that of invoking
# sh -c "$EDITOR \"$@\"" files ...
#
# If our trash directory contains shell metacharacters, they will be
# interpreted if we just set $EDITOR directly, so do a little dance with
# environment variables to work around this.
#
# In particular, quoting isn't enough, as the path may contain the same quote
# that we're using.
test_set_editor () {
	FAKE_EDITOR="$1"
	export FAKE_EDITOR
	VISUAL='"$FAKE_EDITOR"'
	export VISUAL
}

# You are not expected to call test_ok_ and test_failure_ directly, use
# the text_expect_* functions instead.

test_ok_ () {
	test_success=$(($test_success + 1))
	say_color "" "  ok $test_count: $@"
}

test_failure_ () {
	test_failure=$(($test_failure + 1))
	say_color error "FAIL $test_count: $1"
	shift
	echo "$@" | sed -e 's/^/	/'
	test "$immediate" = "" || { trap - EXIT; exit 1; }
}

test_known_broken_ok_ () {
	test_fixed=$(($test_fixed+1))
	say_color "" "  FIXED $test_count: $@"
}

test_known_broken_failure_ () {
	test_broken=$(($test_broken+1))
	say_color skip "  still broken $test_count: $@"
}

test_debug () {
	test "$debug" = "" || eval "$1"
}

test_run_ () {
	eval >&3 2>&4 "$1"
	eval_ret="$?"
	return 0
}

test_skip () {
	test_count=$(($test_count+1))
	to_skip=
	for skp in $SKIP_TESTS
	do
		case $this_test.$test_count in
		$skp)
			to_skip=t
		esac
	done
	case "$to_skip" in
	t)
		say_color skip >&3 "skipping test: $@"
		say_color skip "skip $test_count: $1"
		: true
		;;
	*)
		false
		;;
	esac
}

test_expect_failure () {
	test "$#" = 2 ||
	error "bug in the test script: not 2 parameters to test-expect-failure"
	if ! test_skip "$@"
	then
		say >&3 "checking known breakage: $2"
		test_run_ "$2"
		if [ "$?" = 0 -a "$eval_ret" = 0 ]
		then
			test_known_broken_ok_ "$1"
		else
		    test_known_broken_failure_ "$1"
		fi
	fi
	echo >&3 ""
}

test_expect_success () {
	test "$#" = 2 ||
	error "bug in the test script: not 2 parameters to test-expect-success"
	if ! test_skip "$@"
	then
		say >&3 "expecting success: $2"
		test_run_ "$2"
		if [ "$?" = 0 -a "$eval_ret" = 0 ]
		then
			test_ok_ "$1"
		else
			test_failure_ "$@"
		fi
	fi
	echo >&3 ""
}

test_expect_code () {
	test "$#" = 3 ||
	error "bug in the test script: not 3 parameters to test-expect-code"
	if ! test_skip "$@"
	then
		say >&3 "expecting exit code $1: $3"
		test_run_ "$3"
		if [ "$?" = 0 -a "$eval_ret" = "$1" ]
		then
			test_ok_ "$2"
		else
			test_failure_ "$@"
		fi
	fi
	echo >&3 ""
}

# test_external runs external test scripts that provide continuous
# test output about their progress, and succeeds/fails on
# zero/non-zero exit code.  It outputs the test output on stdout even
# in non-verbose mode, and announces the external script with "* run
# <n>: ..." before running it.  When providing relative paths, keep in
# mind that all scripts run in "trash directory".
# Usage: test_external description command arguments...
# Example: test_external 'Perl API' perl ../path/to/test.pl
test_external () {
	test "$#" -eq 3 ||
	error >&5 "bug in the test script: not 3 parameters to test_external"
	descr="$1"
	shift
	if ! test_skip "$descr" "$@"
	then
		# Announce the script to reduce confusion about the
		# test output that follows.
		say_color "" " run $test_count: $descr ($*)"
		# Run command; redirect its stderr to &4 as in
		# test_run_, but keep its stdout on our stdout even in
		# non-verbose mode.
		"$@" 2>&4
		if [ "$?" = 0 ]
		then
			test_ok_ "$descr"
		else
			test_failure_ "$descr" "$@"
		fi
	fi
}

# Like test_external, but in addition tests that the command generated
# no output on stderr.
test_external_without_stderr () {
	# The temporary file has no (and must have no) security
	# implications.
	tmp="$TMPDIR"; if [ -z "$tmp" ]; then tmp=/tmp; fi
	stderr="$tmp/todotxt-external-stderr.$$.tmp"
	test_external "$@" 4> "$stderr"
	[ -f "$stderr" ] || error "Internal error: $stderr disappeared."
	descr="no stderr: $1"
	shift
	say >&3 "expecting no stderr from previous command"
	if [ ! -s "$stderr" ]; then
		rm "$stderr"
		test_ok_ "$descr"
	else
		if [ "$verbose" = t ]; then
			output=`echo; echo Stderr is:; cat "$stderr"`
		else
			output=
		fi
		# rm first in case test_failure exits.
		rm "$stderr"
		test_failure_ "$descr" "$@" "$output"
	fi
}

# This is not among top-level (test_expect_success | test_expect_failure)
# but is a prefix that can be used in the test script, like:
#
#	test_expect_success 'complain and die' '
#           do something &&
#           do something else &&
#	    test_must_fail git checkout ../outerspace
#	'
#
# Writing this as "! git checkout ../outerspace" is wrong, because
# the failure could be due to a segv.  We want a controlled failure.

test_must_fail () {
	"$@"
	test $? -gt 0 -a $? -le 129 -o $? -gt 192
}

# test_cmp is a helper function to compare actual and expected output.
# You can use it like:
#
#	test_expect_success 'foo works' '
#		echo expected >expected &&
#		foo >actual &&
#		test_cmp expected actual
#	'
#
# This could be written as either "cmp" or "diff -u", but:
# - cmp's output is not nearly as easy to read as diff -u
# - not all diff versions understand "-u"

test_cmp() {
	diff -u "$@"
}

test_done () {
	trap - EXIT
	test_results_dir="$TEST_DIRECTORY/test-results"
	mkdir -p "$test_results_dir"
	test_results_path="$test_results_dir/${0%.sh}-$$"

	echo "total $test_count" >> $test_results_path
	echo "success $test_success" >> $test_results_path
	echo "fixed $test_fixed" >> $test_results_path
	echo "broken $test_broken" >> $test_results_path
	echo "failed $test_failure" >> $test_results_path
	echo "" >> $test_results_path

	if test "$test_fixed" != 0
	then
		say_color pass "fixed $test_fixed known breakage(s)"
	fi
	if test "$test_broken" != 0
	then
		say_color error "still have $test_broken known breakage(s)"
		msg="remaining $(($test_count-$test_broken)) test(s)"
	else
		msg="$test_count test(s)"
	fi
	case "$test_failure" in
	0)
		say_color pass "passed all $msg"

                # Clean up this test.
		test -d "$remove_trash" &&
		cd "$(dirname "$remove_trash")" &&
		rm -rf "$(basename "$remove_trash")"

		exit 0 ;;

	*)
		say_color error "failed $test_failure among $msg"
		exit 1 ;;

	esac
}

# Use -P to resolve symlinks in our working directory so that the pwd
# in subprocesses equals our $PWD (for pathname comparisons).
cd -P .

# Record our location for reference.
TEST_DIRECTORY=$(pwd)

# Test repository
test="trash directory.$(basename "$0" .sh)"
test ! -z "$debug" || remove_trash="$TEST_DIRECTORY/$test"
rm -fr "$test" || {
	trap - EXIT
	echo >&5 "FATAL: Cannot prepare test area"
	exit 1
}

# Most tests can use the created repository, but some may need to create more.
# Usage: test_init_todo <directory>
test_init_todo () {
	test "$#" = 1 ||
	error "bug in the test script: not 1 parameter to test_init_todo"
	owd=`pwd`
	root="$1"
	mkdir -p "$root"
	cd "$root" || error "Cannot setup todo dir in $root"
        # Initialize the configuration file. Carefully quoted.
        sed -e 's|TODO_DIR=.*$|TODO_DIR="'"$TEST_DIRECTORY/$test"'"|' $TEST_DIRECTORY/../todo.cfg > todo.cfg

	# Install latest todo.sh
	mkdir bin
	ln -s "$TEST_DIRECTORY/../todo.sh" bin/todo.sh

	# Initialize a hack date script
	TODO_TEST_REAL_DATE=$(which date)
	TODO_TEST_TIME=1234500000
	export PATH TODO_TEST_REAL_DATE TODO_TEST_TIME

	# Trying to detect the version of "date" on current system
	DATE_STYLE=unknown
	# on GNU systems (versions may vary):
	#date --version
	#date (GNU coreutils) 6.10
	#...
	if date --version 2>&1 | grep -q "GNU"; then
		DATE_STYLE=GNU
	# on Mac OS X 10.5:
	#date --version
	#date: illegal option -- -
	#usage: date [-jnu] [-d dst] [-r seconds] [-t west] [-v[+|-]val[ymwdHMS]] ...
	#[-f fmt date | [[[mm]dd]HH]MM[[cc]yy][.ss]] [+format]
	elif date --version 2>&1 | grep -q -e "-jnu"; then
		DATE_STYLE=Mac10.5
	# on Mac OS X 10.4:
	#date --version
	#date: illegal option -- -
	#usage: date [-nu] [-r seconds] [+format]
	#       date [[[[[cc]yy]mm]dd]hh]mm[.ss]
	elif date --version 2>&1 | grep -q -e "-nu"; then
		DATE_STYLE=Mac10.4
	fi

	case $DATE_STYLE in
		GNU)
			cat > bin/date <<-EOF
			#!/bin/sh
			exec "$TODO_TEST_REAL_DATE" -d @\$TODO_TEST_TIME \$@
			EOF
			chmod 755 bin/date
		;;
		Mac10.5)
			cat > bin/date <<-EOF
			#!/bin/sh
			exec "$TODO_TEST_REAL_DATE" -j -f %s \$TODO_TEST_TIME \$@
			EOF
			chmod 755 bin/date
		;;
		Mac10.4)
			cat > bin/date <<-EOF
			#!/bin/sh
			exec "$TODO_TEST_REAL_DATE" -r \$TODO_TEST_TIME \$@
			EOF
			chmod 755 bin/date
		;;
		*)
			echo "WARNING: Current date executable not recognized"
			echo "So today date will be used, expect false negative tests..."
		;;
	esac

	# Ensure a correct PATH for testing.
	PATH=$owd/$root/bin:$PATH
	export PATH

	cd "$owd"
}

# Usage: test_tick [increment]
test_tick () {
	TODO_TEST_TIME=$(($TODO_TEST_TIME + ${1:-86400}))
}

# Generate and run a series of tests based on a transcript.
# Usage: test_todo_session "description" <<EOF
# >>> command
# output1
# output2
# >>> command
# === exit status
# output3
# output4
# EOF
test_todo_session () {
    test "$#" = 1 ||
    error "bug in the test script: extra args to test_todo_session"
    subnum=1
    cmd=""
    status=0
    > expect
    while read line
    do
	case $line in
	">>> "*)
	    test -z "$cmd" || error "bug in the test script: missing blank line separator in test_todo_session"
	    cmd=${line#>>> }
	    ;;
	"=== "*)
	    status=${line#=== }
	    ;;
	"")
	    if [ ! -z "$cmd" ]; then
		if [ $status = 0 ]; then
		    test_expect_success "$1 $subnum" "$cmd > output && test_cmp expect output"
		else
		    test_expect_success "$1 $subnum" "$cmd > output || test $? = $status && test_cmp expect output"
		fi

		subnum=$(($subnum + 1))
		cmd=""
		status=0
		> expect
	    fi
	    ;;
	*)
	    echo $line >> expect
	    ;;
	esac
    done
    if [ ! -z "$cmd" ]; then
	if [ $status = 0 ]; then
	    test_expect_success "$1 $subnum" "$cmd > output && test_cmp expect output"
	else
	    test_expect_success "$1 $subnum" "$cmd > output || test $? = $status && test_cmp expect output"
	fi
    fi
}

test_shell () {
	trap - EXIT
	export PS1='$(ret_val=$?; [ "$ret_val" != "0" ] && echo -e "=== $ret_val\n\n>>> "||echo "\n>>> ")'
	cat <<EOF
Do your tests session here and
don't forget to replace the hardcoded path with \$HOME in the transcript:
$HOME/todo.txt => \$HOME/todo.txt
EOF
	bash --noprofile --norc
	exit 0
}

test_init_todo "$test"
# Use -P to resolve symlinks in our working directory so that the pwd
# in subprocesses equals our $PWD (for pathname comparisons).
cd -P "$test" || exit 1

# Since todo.sh refers to the home directory often,
# make sure we don't accidentally grab the tester's config
# but use something specified by the framework.
HOME=$(pwd)
export HOME

this_test=${0##*/}
this_test=${this_test%%-*}
for skp in $SKIP_TESTS
do
	to_skip=
	for skp in $SKIP_TESTS
	do
		case "$this_test" in
		$skp)
			to_skip=t
		esac
	done
	case "$to_skip" in
	t)
		say_color skip >&3 "skipping test $this_test altogether"
		say_color skip "skip all tests in $this_test"
		test_done
	esac
done
