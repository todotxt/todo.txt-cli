#!/bin/sh

test_description='done functionality
'
. ./test-lib.sh

#DATE=`date '+%Y-%m-%d'`

test_todo_session 'done usage' <<EOF
>>> export TODOTXT_FORCE=1

>>> todo.sh done
usage: todo.sh done "TODO ITEM"
=== 1
EOF

cat > todo.txt <<EOF
stop
remove1
remove2
remove3
remove4
EOF

test_todo_session 'basic done' <<EOF
>>> todo.sh lsa
2 remove1
3 remove2
4 remove3
5 remove4
1 stop
--
TODO: 5 of 5 tasks shown

>>> todo.sh done smell the uppercase Roses
TODO: 'smell the uppercase Roses' marked as done.

>>> todo.sh done notice the sunflowers
TODO: 'notice the sunflowers' marked as done.

>>> todo.sh lsa
2 remove1
3 remove2
4 remove3
5 remove4
1 stop
7 x 2009-02-13 notice the sunflowers
6 x 2009-02-13 smell the uppercase Roses
--
TODO: 7 of 7 tasks shown
EOF
test_done
