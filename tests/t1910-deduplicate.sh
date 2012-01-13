#!/bin/sh

test_description='deduplicate functionality

Ensure we can deduplicate items successfully.
'
. ./test-lib.sh

cat >> todo.txt<<EOF
duplicated
two
x done
duplicated
double task
double task
three
EOF

test_todo_session 'deduplicate with duplicates' <<EOF
>>> todo.sh deduplicate
TODO: 2 duplicate task(s) removed

>>> todo.sh -p ls
4 double task
1 duplicated
5 three
2 two
3 x done
--
TODO: 5 of 5 tasks shown
EOF

test_todo_session 'deduplicate without duplicates' <<EOF
>>> todo.sh deduplicate
TODO: No duplicate tasks found
EOF

test_done
