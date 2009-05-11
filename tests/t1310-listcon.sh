#!/bin/sh
#

test_description='listcon functionality

This test checks basic context listing functionality
'
. ./test-lib.sh

cat > todo.txt <<EOF
item 1
item 2
item 3
EOF
test_expect_success 'listcon no contexts' '
    todo.sh listcon > output && ! test -s output
'

cat > todo.txt <<EOF
(A) @1 -- Some context 1 task, whitespace, one char
(A) @c2 -- Some context 2 task, whitespace, two char
@con03 -- Some context 3 task, no whitespace
@con04 -- Some context 4 task, no whitespace
@con05@con06 -- weird context
EOF
test_todo_session 'Single context per line' <<EOF
>>> todo.sh listcon
@1
@c2
@con03
@con04
@con05@con06
EOF

cat > todo.txt <<EOF
@con01 -- Some context 1 task
@con02 -- Some context 2 task
@con02 @con03 -- Multi-context task
EOF
test_todo_session 'Multi-context per line' <<EOF
>>> todo.sh listcon
@con01
@con02
@con03
EOF

cat > todo.txt <<EOF
@con01 -- Some context 1 task
@con02 -- Some context 2 task
@con02 ginatrapani@gmail.com -- Some context 2 task
EOF
test_todo_session 'listcon e-mail address test' <<EOF
>>> todo.sh listcon
@con01
@con02
EOF

test_done
