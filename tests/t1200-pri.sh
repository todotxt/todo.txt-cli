#!/bin/bash

test_description='basic priority functionality
'
. ./test-lib.sh

test_todo_session 'priority usage' <<EOF
>>> todo.sh pri B B
usage: todo.sh pri NR PRIORITY [NR PRIORITY ...]
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

cat > todo.txt <<EOF
smell the uppercase Roses +flowers @outside
notice the sunflowers
stop
EOF
test_todo_session 'multiple priority' <<EOF
>>> todo.sh pri 1 A 2 B
1 (A) smell the uppercase Roses +flowers @outside
TODO: 1 prioritized (A).
2 (B) notice the sunflowers
TODO: 2 prioritized (B).
EOF

test_todo_session 'multiple reprioritize' <<EOF
>>> todo.sh pri 1 Z 2 X
1 (Z) smell the uppercase Roses +flowers @outside
TODO: 1 re-prioritized from (A) to (Z).
2 (X) notice the sunflowers
TODO: 2 re-prioritized from (B) to (X).
EOF

test_todo_session 'multiple prioritize error' <<EOF
>>> todo.sh pri 1 B 4 B
=== 1
1 (B) smell the uppercase Roses +flowers @outside
TODO: 1 re-prioritized from (Z) to (B).
TODO: No task 4.

>>> todo.sh pri 1 C 4 B 3 A
=== 1
1 (C) smell the uppercase Roses +flowers @outside
TODO: 1 re-prioritized from (B) to (C).
TODO: No task 4.
EOF
test_done
