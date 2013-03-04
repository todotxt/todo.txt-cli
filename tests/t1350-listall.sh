#!/bin/bash

test_description='listall functionality
'
. ./test-lib.sh

cat > todo.txt <<EOF
smell the uppercase Roses +flowers @outside
x 2011-08-08 tend the garden @outside
notice the sunflowers
x 2011-12-26 go outside +wakeup
(A) stop
EOF
cat > done.txt <<EOF
x 2011-12-01 eat breakfast
x 2011-12-05 smell the coffee +wakeup
EOF

test_todo_session 'basic listall' <<EOF
>>> todo.sh -p listall
5 (A) stop
3 notice the sunflowers
1 smell the uppercase Roses +flowers @outside
2 x 2011-08-08 tend the garden @outside
0 x 2011-12-01 eat breakfast
0 x 2011-12-05 smell the coffee +wakeup
4 x 2011-12-26 go outside +wakeup
--
TODO: 5 of 5 tasks shown
DONE: 2 of 2 tasks shown
total 7 of 7 tasks shown
EOF

test_todo_session 'listall highlighting' <<EOF
>>> todo.sh listall
[1;33m5 (A) stop[0m
3 notice the sunflowers
1 smell the uppercase Roses +flowers @outside
[0;37m2 x 2011-08-08 tend the garden @outside[0m
[0;37m0 x 2011-12-01 eat breakfast[0m
[0;37m0 x 2011-12-05 smell the coffee +wakeup[0m
[0;37m4 x 2011-12-26 go outside +wakeup[0m
--
TODO: 5 of 5 tasks shown
DONE: 2 of 2 tasks shown
total 7 of 7 tasks shown
EOF

test_todo_session 'listall nonverbose' <<EOF
>>> TODOTXT_VERBOSE=0 todo.sh -p listall
5 (A) stop
3 notice the sunflowers
1 smell the uppercase Roses +flowers @outside
2 x 2011-08-08 tend the garden @outside
0 x 2011-12-01 eat breakfast
0 x 2011-12-05 smell the coffee +wakeup
4 x 2011-12-26 go outside +wakeup
EOF

test_todo_session 'listall filtering' <<EOF
>>> todo.sh -p listall @outside
1 smell the uppercase Roses +flowers @outside
2 x 2011-08-08 tend the garden @outside
--
TODO: 2 of 5 tasks shown
DONE: 0 of 2 tasks shown
total 2 of 7 tasks shown

>>> todo.sh -p listall the
3 notice the sunflowers
1 smell the uppercase Roses +flowers @outside
2 x 2011-08-08 tend the garden @outside
0 x 2011-12-05 smell the coffee +wakeup
--
TODO: 3 of 5 tasks shown
DONE: 1 of 2 tasks shown
total 4 of 7 tasks shown

>>> todo.sh -p listall breakfast
0 x 2011-12-01 eat breakfast
--
TODO: 0 of 5 tasks shown
DONE: 1 of 2 tasks shown
total 1 of 7 tasks shown

>>> todo.sh -p listall doesnotmatch
--
TODO: 0 of 5 tasks shown
DONE: 0 of 2 tasks shown
total 0 of 7 tasks shown
EOF

cat >> done.txt <<EOF
x 2010-01-01 old task 1
x 2010-01-01 old task 2
x 2010-01-01 old task 3
x 2010-01-01 old task 4
EOF
test_todo_session 'listall number width' <<EOF
>>> todo.sh -p listall
5 (A) stop
3 notice the sunflowers
1 smell the uppercase Roses +flowers @outside
0 x 2010-01-01 old task 1
0 x 2010-01-01 old task 2
0 x 2010-01-01 old task 3
0 x 2010-01-01 old task 4
2 x 2011-08-08 tend the garden @outside
0 x 2011-12-01 eat breakfast
0 x 2011-12-05 smell the coffee +wakeup
4 x 2011-12-26 go outside +wakeup
--
TODO: 5 of 5 tasks shown
DONE: 6 of 6 tasks shown
total 11 of 11 tasks shown

>>> TODOTXT_VERBOSE=0 todo.sh add new task 1

>>> TODOTXT_VERBOSE=0 todo.sh add new task 2

>>> TODOTXT_VERBOSE=0 todo.sh add new task 3

>>> TODOTXT_VERBOSE=0 todo.sh add new task 4

>>> TODOTXT_VERBOSE=0 todo.sh add new task 5

>>> todo.sh -p listall
05 (A) stop
06 new task 1
07 new task 2
08 new task 3
09 new task 4
10 new task 5
03 notice the sunflowers
01 smell the uppercase Roses +flowers @outside
00 x 2010-01-01 old task 1
00 x 2010-01-01 old task 2
00 x 2010-01-01 old task 3
00 x 2010-01-01 old task 4
02 x 2011-08-08 tend the garden @outside
00 x 2011-12-01 eat breakfast
00 x 2011-12-05 smell the coffee +wakeup
04 x 2011-12-26 go outside +wakeup
--
TODO: 10 of 10 tasks shown
DONE: 6 of 6 tasks shown
total 16 of 16 tasks shown
EOF

test_done
