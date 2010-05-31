#!/bin/sh

test_description='basic replace functionality

Ensure we can replace items successfully.
'
. ./test-lib.sh

#
# Set up the basic todo.txt
#
todo.sh add notice the daisies > /dev/null

test_todo_session 'replace usage' <<EOF
>>> todo.sh replace adf asdfa
=== 1
usage: todo.sh replace ITEM# "UPDATED ITEM"
EOF

test_todo_session 'basic replace' <<EOF
>>> todo.sh replace 1 "smell the cows"
1: notice the daisies
replaced with
1: smell the cows

>>> todo.sh list
1 smell the cows
--
TODO: 1 of 1 tasks shown

>>> todo.sh replace 1 smell the roses
1: smell the cows
replaced with
1: smell the roses

>>> todo.sh list
1 smell the roses
--
TODO: 1 of 1 tasks shown
EOF

cat > todo.txt <<EOF
smell the cows
grow some corn
thrash some hay
chase the chickens
EOF
test_todo_session 'replace in multi-item file' <<EOF
>>> todo.sh replace 1 smell the cheese
1: smell the cows
replaced with
1: smell the cheese

>>> todo.sh replace 3 jump on hay
3: thrash some hay
replaced with
3: jump on hay

>>> todo.sh replace 4 collect the eggs
4: chase the chickens
replaced with
4: collect the eggs
EOF

test_todo_session 'replace with priority' <<EOF
>>> todo.sh pri 4 a
4: (A) collect the eggs
TODO: 4 prioritized (A).

>>> todo.sh replace 4 "collect the bread"
4: (A) collect the eggs
replaced with
4: (A) collect the bread

>>> todo.sh replace 4 collect the eggs
4: (A) collect the bread
replaced with
4: (A) collect the eggs
EOF
test_todo_session 'replace with &' << EOF
>>> todo.sh replace 3 "thrash the hay & thresh the wheat"
3: jump on hay
replaced with 
3: thrash the hay & thresh the wheat
EOF

test_todo_session 'replace error' << EOF
>>> todo.sh replace 10 "hej!"
=== 1
10: No such task.
EOF

test_done
