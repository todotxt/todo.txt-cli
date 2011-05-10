#!/bin/sh

test_description='list priority functionality
'
. ./test-lib.sh

test_todo_session 'listpri usage' <<EOF
>>> todo.sh listpri ?
usage: todo.sh listpri PRIORITY
note: PRIORITY must a single letter from A to Z.
=== 1
EOF

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
(C) notice the sunflowers
stop
EOF
test_todo_session 'basic listpri' <<EOF
>>> todo.sh listpri A
--
TODO: 0 of 3 tasks shown

>>> todo.sh -p listpri c
2 (C) notice the sunflowers
--
TODO: 1 of 3 tasks shown
EOF

test_todo_session 'listpri highlighting' <<EOF
>>> todo.sh listpri
[0;32m1 (B) smell the uppercase Roses +flowers @outside[0m
[1;34m2 (C) notice the sunflowers[0m
--
TODO: 2 of 3 tasks shown
EOF

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
(C) notice the sunflowers
(m)others will notice this
(n) not a prioritized task
notice the (C)opyright
EOF
test_todo_session 'listpri filtering' <<EOF
>>> todo.sh -p listpri
1 (B) smell the uppercase Roses +flowers @outside
2 (C) notice the sunflowers
--
TODO: 2 of 5 tasks shown

>>> todo.sh -p listpri b
1 (B) smell the uppercase Roses +flowers @outside
--
TODO: 1 of 5 tasks shown

>>> todo.sh -p listpri c
2 (C) notice the sunflowers
--
TODO: 1 of 5 tasks shown

>>> todo.sh -p listpri m
--
TODO: 0 of 5 tasks shown

>>> todo.sh -p listpri n
--
TODO: 0 of 5 tasks shown
EOF

test_done
