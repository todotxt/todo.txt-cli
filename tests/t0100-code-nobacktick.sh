#!/bin/sh

test_description='no old-style backtick command substitution

This test checks the todo.sh script itself for occurrences
of old-style backtick command substitution, which should be
replaced with $(...).
'
. ./test-lib.sh

test_todo_session 'no old-style backtick command substitution' <<EOF
>>> sed -n -e 's/[ \t]#.*//' -e '/\d96/{=;p}' "$(which todo.sh)"
EOF

test_done
