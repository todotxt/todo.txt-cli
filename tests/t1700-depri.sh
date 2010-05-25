#!/bin/sh

test_description='basic depriority functionality
'
. ./test-lib.sh

test_todo_session 'depriority usage' <<EOF
>>> todo.sh depri B B
usage: todo.sh depri ITEM#
=== 1
EOF

test_todo_session 'depriority nonexistant item' <<EOF
>>> todo.sh depri 42
42: No such todo.
=== 1
EOF

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
(A) notice the sunflowers
stop
EOF
test_todo_session 'basic depriority' <<EOF
>>> todo.sh -p list
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
3 stop
--
TODO: 3 of 3 tasks shown

>>> todo.sh depri 1
1: smell the uppercase Roses +flowers @outside
TODO: 1 deprioritized.

>>> todo.sh -p list
2 (A) notice the sunflowers
1 smell the uppercase Roses +flowers @outside
3 stop
--
TODO: 3 of 3 tasks shown
EOF

test_done
