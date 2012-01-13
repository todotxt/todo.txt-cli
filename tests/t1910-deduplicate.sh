#!/bin/sh

test_description='deduplicate functionality

Ensure we can deduplicate items successfully.
'
. ./test-lib.sh

cat > todo.txt <<EOF
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

cat > todo.txt <<EOF
normal task
a [1mbold[0m action
something else
a [1mbold[0m action
something more
EOF
test_todo_session 'deduplicate with non-printable duplicates' <<EOF
>>> todo.sh deduplicate
TODO: 1 duplicate task(s) removed

>>> todo.sh -p ls
2 a [1mbold[0m action
1 normal task
3 something else
4 something more
--
TODO: 4 of 4 tasks shown
EOF

test_done
