#!/bin/bash

test_description='basic priority functionality
'
. ./test-lib.sh

test_todo_session 'priority usage' <<EOF
>>> todo.sh pri B B
usage: todo.sh pri ITEM# PRIORITY
note: PRIORITY must be anywhere from A to Z.
=== 1
EOF

cat > todo.txt <<EOF
smell the uppercase Roses +flowers @outside
notice the sunflowers
stop
EOF
test_todo_session 'basic priority' <<EOF
>>> todo.sh list
2 notice the sunflowers
1 smell the uppercase Roses +flowers @outside
3 stop
--
TODO: 3 of 3 tasks shown

>>> todo.sh pri 1 B
1 (B) smell the uppercase Roses +flowers @outside
TODO: 1 prioritized (B).

>>> todo.sh list
[0;32m1 (B) smell the uppercase Roses +flowers @outside[0m
2 notice the sunflowers
3 stop
--
TODO: 3 of 3 tasks shown

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
2 notice the sunflowers
3 stop
--
TODO: 3 of 3 tasks shown

>>> todo.sh pri 2 C
2 (C) notice the sunflowers
TODO: 2 prioritized (C).

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
2 (C) notice the sunflowers
3 stop
--
TODO: 3 of 3 tasks shown

>>> todo.sh add "smell the coffee +wakeup"
4 smell the coffee +wakeup
TODO: 4 added.

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
2 (C) notice the sunflowers
4 smell the coffee +wakeup
3 stop
--
TODO: 4 of 4 tasks shown
EOF

test_todo_session 'priority error' <<EOF
>>> todo.sh pri 10 B
=== 1
TODO: No task 10.
EOF

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
(C) notice the sunflowers
stop
EOF
test_todo_session 'reprioritize' <<EOF
>>> todo.sh pri 2 A
2 (A) notice the sunflowers
TODO: 2 re-prioritized from (C) to (A).

>>> todo.sh -p list
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
3 stop
--
TODO: 3 of 3 tasks shown

>>> todo.sh pri 2 a
2 (A) notice the sunflowers
TODO: 2 already prioritized (A).

>>> todo.sh -p list
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
3 stop
--
TODO: 3 of 3 tasks shown
EOF

test_done
