#!/bin/bash

test_description='no old-style backtick command substitution

This test checks the todo.sh script itself for occurrences
of old-style backtick command substitution, which should be
replaced with $(...).
On failure, it will print each offending line number and line.
'
. ./test-lib.sh

backtick_check()
{
    sed -n -e 's/\(^\|[ \t]\)#.*//' -e '/`/{' -e '=;p' -e '}' "$@"
}

test_todo_session 'no old-style backtick command substitution' <<EOF
>>> backtick_check bin/todo.sh

>>> backtick_check ../../todo.cfg
EOF

test_done
