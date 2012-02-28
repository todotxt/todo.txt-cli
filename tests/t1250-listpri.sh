#!/bin/bash

test_description='list priority functionality
'
. ./test-lib.sh

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
test_todo_session 'listpri filtering priorities' <<EOF
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

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
(X) clean the house from A-Z
(C) notice the sunflowers
(X) listen to music
buy more records from artists A-Z
EOF
test_todo_session 'listpri filtering priority ranges' <<EOF
>>> todo.sh -p listpri a-c
1 (B) smell the uppercase Roses +flowers @outside
3 (C) notice the sunflowers
--
TODO: 2 of 5 tasks shown

>>> todo.sh -p listpri c-Z
3 (C) notice the sunflowers
2 (X) clean the house from A-Z
4 (X) listen to music
--
TODO: 3 of 5 tasks shown

>>> todo.sh -p listpri A-
2 (X) clean the house from A-Z
--
TODO: 1 of 5 tasks shown

>>> todo.sh -p listpri A-C A-Z
--
TODO: 0 of 5 tasks shown

>>> todo.sh -p listpri X A-Z
2 (X) clean the house from A-Z
--
TODO: 1 of 5 tasks shown
EOF

cat > todo.txt <<EOF
(B) ccc xxx this line should be third.
ccc xxx this line should be third.
(A) aaa zzz this line should be first.
aaa zzz this line should be first.
(B) bbb yyy this line should be second.
bbb yyy this line should be second.
EOF
test_todo_session 'listpri filtering of TERM' <<EOF
>>> todo.sh -p listpri "should be"
3 (A) aaa zzz this line should be first.
5 (B) bbb yyy this line should be second.
1 (B) ccc xxx this line should be third.
--
TODO: 3 of 6 tasks shown

>>> todo.sh -p listpri a "should be"
3 (A) aaa zzz this line should be first.
--
TODO: 1 of 6 tasks shown

>>> todo.sh -p listpri b second
5 (B) bbb yyy this line should be second.
--
TODO: 1 of 6 tasks shown

>>> todo.sh -p listpri x "should be"
--
TODO: 0 of 6 tasks shown
EOF

test_done
