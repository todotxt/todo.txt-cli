#!/bin/bash
#

test_description='basic move functionality
'
. ./test-lib.sh

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
(A) notice the sunflowers
EOF
cat > done.txt <<EOF
x 2009-02-13 make the coffee +wakeup
x 2009-02-13 smell the coffee +wakeup
EOF
test_todo_session 'basic move with implicit source' <<EOF
>>> todo.sh -f move 1 done.txt | sed "s#'[^']\{1,\}/\([^/']\{1,\}\)'#'\1'#g"
1 (B) smell the uppercase Roses +flowers @outside
TODO: 1 moved from 'todo.txt' to 'done.txt'.

>>> todo.sh -p ls
2 (A) notice the sunflowers
--
TODO: 1 of 1 tasks shown

>>> todo.sh -p listfile done.txt
3 (B) smell the uppercase Roses +flowers @outside
1 x 2009-02-13 make the coffee +wakeup
2 x 2009-02-13 smell the coffee +wakeup
--
DONE: 3 of 3 tasks shown
EOF

test_todo_session 'basic move with passed source' <<EOF
>>> todo.sh -f move 2 todo.txt done.txt | sed "s#'[^']\{1,\}/\([^/']\{1,\}\)'#'\1'#g"
2 x 2009-02-13 smell the coffee +wakeup
TODO: 2 moved from 'done.txt' to 'todo.txt'.

>>> todo.sh -p ls
2 (A) notice the sunflowers
3 x 2009-02-13 smell the coffee +wakeup
--
TODO: 2 of 2 tasks shown

>>> todo.sh -p listfile done.txt
3 (B) smell the uppercase Roses +flowers @outside
1 x 2009-02-13 make the coffee +wakeup
--
DONE: 2 of 2 tasks shown
EOF

echo -n 'this is a first task without newline' > todo.txt
cat > done.txt <<EOF
x 2009-02-13 make the coffee +wakeup
x 2009-02-13 smell the coffee +wakeup
EOF
test_todo_session 'move to destination without EOL' <<EOF
>>> todo.sh -f move 2 todo.txt done.txt | sed "s#'[^']\{1,\}/\([^/']\{1,\}\)'#'\1'#g"
2 x 2009-02-13 smell the coffee +wakeup
TODO: 2 moved from 'done.txt' to 'todo.txt'.

>>> todo.sh -p ls
1 this is a first task without newline
2 x 2009-02-13 smell the coffee +wakeup
--
TODO: 2 of 2 tasks shown

>>> todo.sh -p listfile done.txt
1 x 2009-02-13 make the coffee +wakeup
--
DONE: 1 of 1 tasks shown
EOF

test_done
