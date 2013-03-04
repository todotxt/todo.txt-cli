#!/bin/bash

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
TODO: No task 42.
=== 1

>>> todo.sh -f del 42 Roses
TODO: No task 42.
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
1 (B) smell the uppercase Roses +flowers @outside
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
stop
EOF
test_todo_session 'del preserving line numbers' <<EOF
>>> todo.sh -f del 1
1 (B) smell the uppercase Roses +flowers @outside
TODO: 1 deleted.

>>> todo.sh -f del 1
TODO: No task 1.
=== 1

>>> todo.sh add A new task
4 A new task
TODO: 4 added.

>>> todo.sh -p list
2 (A) notice the sunflowers
4 A new task
3 stop
--
TODO: 3 of 3 tasks shown

>>> todo.sh -f -n del 2
2 (A) notice the sunflowers
TODO: 2 deleted.

>>> todo.sh add Another new task
3 Another new task
TODO: 3 added.

>>> todo.sh -p list
2 A new task
3 Another new task
1 stop
--
TODO: 3 of 3 tasks shown
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
1 (B) smell the uppercase Roses +flowers @outside
TODO: Removed 'uppercase' from task.
1 (B) smell the Roses +flowers @outside

>>> todo.sh -p list
2 (A) notice the sunflowers
1 (B) smell the Roses +flowers @outside
3 (C) stop
--
TODO: 3 of 3 tasks shown

>>> todo.sh del 1 "the Roses"
1 (B) smell the Roses +flowers @outside
TODO: Removed 'the Roses' from task.
1 (B) smell +flowers @outside

>>> todo.sh del 1 m
1 (B) smell +flowers @outside
TODO: Removed 'm' from task.
1 (B) sell +flowers @outside

>>> todo.sh del 1 @outside
1 (B) sell +flowers @outside
TODO: Removed '@outside' from task.
1 (B) sell +flowers

>>> todo.sh del 1 sell
1 (B) sell +flowers
TODO: Removed 'sell' from task.
1 (B) +flowers
EOF

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
(A) notice the sunflowers
(C) stop
EOF
test_todo_session 'del nonexistant TERM' <<EOF
>>> todo.sh del 1 dung
1 (B) smell the uppercase Roses +flowers @outside
TODO: 'dung' not found; no removal done.
=== 1

>>> todo.sh -p list
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
3 (C) stop
--
TODO: 3 of 3 tasks shown
EOF

test_done
