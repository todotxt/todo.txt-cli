#!/bin/bash

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

test_todo_session 'deduplicate and preserve line numbers' <<EOF
>>> todo.sh deduplicate
TODO: 2 duplicate task(s) removed

>>> todo.sh -p ls
5 double task
1 duplicated
7 three
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
duplicated
two
x done
duplicated
double task
double task
three
EOF
test_todo_session 'deduplicate and delete lines' <<EOF
>>> todo.sh -n deduplicate
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

cat > todo.txt <<EOF
one
duplicated
three
duplicated
duplicated
six
duplicated
EOF
test_todo_session 'deduplicate more than two occurrences' <<EOF
>>> todo.sh deduplicate
TODO: 3 duplicate task(s) removed

>>> todo.sh -p ls
2 duplicated
1 one
6 six
3 three
--
TODO: 4 of 4 tasks shown
EOF

cat > todo.txt <<EOF
normal task
a [1mbold[0m task
something else
a [1mbold[0m task
something more
EOF
test_todo_session 'deduplicate with non-printable duplicates' <<EOF
>>> todo.sh deduplicate
TODO: 1 duplicate task(s) removed

>>> todo.sh -p ls
2 a [1mbold[0m task
1 normal task
3 something else
5 something more
--
TODO: 4 of 4 tasks shown
EOF

test_done
