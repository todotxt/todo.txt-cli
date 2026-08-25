#!/usr/bin/env bash
#

test_description='todo.sh version information

This test ensures that version information is picked up correctly and displayed
on -V.
'
. ./test-lib.sh

test_todo_session 'todo.sh -V displays the dev version without a version file' <<EOF
>>> todo.sh -V | head -n 1
TODO.TXT Command Line Interface v@DEV_VERSION@
EOF

versionFilespec="$(dirname "$(command -v todo.sh)")/VERSION-FILE"
echo 'VERSION=0.0.0' > "$versionFilespec"
test_todo_session 'todo.sh -V displays the version from an adjacent version file' <<EOF
>>> todo.sh -V | head -n 1
TODO.TXT Command Line Interface v0.0.0
EOF
rm -- "$versionFilespec"

versionFilespec=./VERSION-FILE
echo 'VERSION=9.9.9' > "$versionFilespec"
test_todo_session 'todo.sh -V ignores a version file in the current directory' <<EOF
>>> todo.sh -V | head -n 1
TODO.TXT Command Line Interface v@DEV_VERSION@
EOF
rm -- "$versionFilespec"

test_done
