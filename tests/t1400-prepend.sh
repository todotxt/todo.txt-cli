#!/bin/sh

test_description='basic prepend functionality
'
. ./test-lib.sh

test_todo_session 'prepend usage' <<EOF
>>> todo.sh prepend B B
usage: todo.sh prepend ITEM# "TEXT TO PREPEND"
=== 1
EOF

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
notice the sunflowers
stop
EOF
test_todo_session 'basic prepend' <<EOF
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

>>> todo.sh prepend 2 test
2: test notice the sunflowers

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
3 stop
2 test notice the sunflowers
--
TODO: 3 of 3 tasks shown

>>> todo.sh prepend 1 test
1: (B) test smell the uppercase Roses +flowers @outside

>>> todo.sh -p list
1 (B) test smell the uppercase Roses +flowers @outside
3 stop
2 test notice the sunflowers
--
TODO: 3 of 3 tasks shown

EOF

test_todo_session 'prepend with &' <<EOF
>>> todo.sh prepend 3 "no running & jumping now"
3: no running & jumping now stop
EOF

test_done
