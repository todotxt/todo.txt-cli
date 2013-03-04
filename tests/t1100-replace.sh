#!/bin/bash

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
1 notice the daisies
TODO: Replaced task with:
1 smell the cows

>>> todo.sh list
1 smell the cows
--
TODO: 1 of 1 tasks shown

>>> todo.sh replace 1 smell the roses
1 smell the cows
TODO: Replaced task with:
1 smell the roses

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
test_todo_session 'replace error' << EOF
>>> todo.sh replace 10 "hej!"
=== 1
TODO: No task 10.
EOF

test_todo_session 'replace in multi-item file' <<EOF
>>> todo.sh replace 1 smell the cheese
1 smell the cows
TODO: Replaced task with:
1 smell the cheese

>>> todo.sh replace 3 jump on hay
3 thrash some hay
TODO: Replaced task with:
3 jump on hay

>>> todo.sh replace 4 collect the eggs
4 chase the chickens
TODO: Replaced task with:
4 collect the eggs
EOF

echo '(A) collect the eggs' > todo.txt
test_todo_session 'replace with priority' <<EOF
>>> todo.sh replace 1 "collect the bread"
1 (A) collect the eggs
TODO: Replaced task with:
1 (A) collect the bread

>>> todo.sh replace 1 collect the eggs
1 (A) collect the bread
TODO: Replaced task with:
1 (A) collect the eggs
EOF

echo 'jump on hay' > todo.txt
test_todo_session 'replace with &' << EOF
>>> todo.sh replace 1 "thrash the hay & thrash the wheat"
1 jump on hay
TODO: Replaced task with:
1 thrash the hay & thrash the wheat
EOF

echo 'jump on hay' > todo.txt
test_todo_session 'replace with spaces' <<EOF
>>> todo.sh replace 1 "notice the   three   spaces"
1 jump on hay
TODO: Replaced task with:
1 notice the   three   spaces
EOF

cat > todo.txt <<EOF
smell the cows
grow some corn
thrash some hay
chase the chickens
EOF
test_todo_session 'replace with symbols' <<EOF
>>> todo.sh replace 1 "~@#$%^&*()-_=+[{]}|;:',<.>/?"
1 smell the cows
TODO: Replaced task with:
1 ~@#$%^&*()-_=+[{]}|;:',<.>/?

>>> todo.sh replace 2 '\`!\\"'
2 grow some corn
TODO: Replaced task with:
2 \`!\\"

>>> todo.sh list
4 chase the chickens
3 thrash some hay
2 \`!\\"
1 ~@#$%^&*()-_=+[{]}|;:',<.>/?
--
TODO: 4 of 4 tasks shown
EOF

cat /dev/null > todo.txt
test_todo_session 'replace handling prepended date on add' <<EOF
>>> todo.sh -t add "new task"
1 2009-02-13 new task
TODO: 1 added.

>>> todo.sh replace 1 this is just a new one
1 2009-02-13 new task
TODO: Replaced task with:
1 2009-02-13 this is just a new one

>>> todo.sh replace 1 2010-07-04 this also has a new date
1 2009-02-13 this is just a new one
TODO: Replaced task with:
1 2010-07-04 this also has a new date
EOF

cat /dev/null > todo.txt
test_todo_session 'replace handling priority and prepended date on add' <<EOF
>>> todo.sh -t add "new task"
1 2009-02-13 new task
TODO: 1 added.

>>> todo.sh pri 1 A
1 (A) 2009-02-13 new task
TODO: 1 prioritized (A).

>>> todo.sh replace 1 this is just a new one
1 (A) 2009-02-13 new task
TODO: Replaced task with:
1 (A) 2009-02-13 this is just a new one
EOF

echo '(A) 2009-02-13 this is just a new one' > todo.txt
test_todo_session 'replace with prepended date replaces existing date' <<EOF
>>> todo.sh replace 1 2010-07-04 this also has a new date
1 (A) 2009-02-13 this is just a new one
TODO: Replaced task with:
1 (A) 2010-07-04 this also has a new date
EOF

echo '2009-02-13 this is just a new one' > todo.txt
test_todo_session 'replace with prepended priority and date replaces existing date' <<EOF
>>> todo.sh replace 1 '(B) 2010-07-04 this also has a new date'
1 2009-02-13 this is just a new one
TODO: Replaced task with:
1 (B) 2010-07-04 this also has a new date
EOF

test_done
