#!/bin/sh

test_description='basic del functionality
'
. ./test-lib.sh

test_todo_session 'del usage' <<EOF
>>> todo.sh del B
usage: todo.sh del ITEM# [TERM]
=== 1
EOF

test_todo_session 'del nonexistant item' <<EOF
>>> todo.sh -f del 42
42: No such task.
=== 1

>>> todo.sh -f del 42 Roses
42: No such task.
=== 1
EOF

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
(A) notice the sunflowers
stop
EOF
test_todo_session 'basic del' <<EOF
>>> todo.sh -p list
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
3 stop
--
TODO: 3 of 3 tasks shown

>>> todo.sh -f del 1
1: (B) smell the uppercase Roses +flowers @outside
TODO: 1 deleted.

>>> todo.sh -p list
2 (A) notice the sunflowers
3 stop
--
TODO: 2 of 2 tasks shown
EOF

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
(A) notice the sunflowers
(C) stop
EOF
test_todo_session 'basic del TERM' <<EOF
>>> todo.sh -p list
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
3 (C) stop
--
TODO: 3 of 3 tasks shown

>>> todo.sh del 1 uppercase
1: (B) smell the uppercase Roses +flowers @outside
got 'uppercase' removed to become
1: (B) smell the Roses +flowers @outside

>>> todo.sh -p list
2 (A) notice the sunflowers
1 (B) smell the Roses +flowers @outside
3 (C) stop
--
TODO: 3 of 3 tasks shown

>>> todo.sh del 1 "the Roses"
1: (B) smell the Roses +flowers @outside
got 'the Roses' removed to become
1: (B) smell +flowers @outside

>>> todo.sh del 1 m
1: (B) smell +flowers @outside
got 'm' removed to become
1: (B) sell +flowers @outside

>>> todo.sh del 1 @outside
1: (B) sell +flowers @outside
got '@outside' removed to become
1: (B) sell +flowers

>>> todo.sh del 1 sell
1: (B) sell +flowers
got 'sell' removed to become
1: (B) +flowers
EOF

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
(A) notice the sunflowers
(C) stop
EOF
test_todo_session 'del nonexistant TERM' <<EOF
>>> todo.sh del 1 dung
1: (B) smell the uppercase Roses +flowers @outside
'dung' not found; no removal done.
=== 1

>>> todo.sh -p list
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
3 (C) stop
--
TODO: 3 of 3 tasks shown
EOF

test_done
