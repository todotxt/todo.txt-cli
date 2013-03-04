#!/bin/bash
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

cat > todo.txt <<EOF
(B) smell the uppercase Roses +roses @outside +shared
(C) notice the sunflowers +sunflowers @garden +shared +landscape
stop
EOF
test_todo_session 'listcon with project' <<EOF
>>> todo.sh listcon +landscape
@garden
EOF

cat > todo.txt <<EOF
@con01 -- Some context 1 task
EOF
cat > done.txt <<EOF
x 2012-02-21 @done01 -- Some context 1 done task
x 2012-02-21 @done02 -- Some context 2 done task
EOF
test_todo_session 'listcon from done tasks' <<'EOF'
>>> TODOTXT_SOURCEVAR=\$DONE_FILE todo.sh listcon
@done01
@done02
EOF
test_todo_session 'listcon from combined open + done tasks' <<'EOF'
>>> TODOTXT_SOURCEVAR='("$TODO_FILE" "$DONE_FILE")' todo.sh listcon
@con01
@done01
@done02
EOF

test_done
