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
test_done
