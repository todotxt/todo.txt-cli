#!/bin/sh

test_description='basic append functionality

Ensure we can append items successfully.
'
. ./test-lib.sh

#
# Set up the basic todo.txt
#
todo.sh add notice the daisies > /dev/null

test_todo_session 'append usage' <<EOF
>>> todo.sh append adf asdfa
=== 1
usage: todo.sh append ITEM# "TEXT TO APPEND"
EOF

test_todo_session 'basic append' <<EOF
>>> todo.sh append 1 "smell the roses"
1: notice the daisies smell the roses

>>> todo.sh list
1 notice the daisies smell the roses
--
TODO: 1 of 1 tasks shown
EOF

test_todo_session 'basic append with &' <<EOF
>>> todo.sh append 1 "see the wasps & bees"
1: notice the daisies smell the roses see the wasps & bees

>>> todo.sh list
1 notice the daisies smell the roses see the wasps & bees
--
TODO: 1 of 1 tasks shown
EOF


test_todo_session 'append error' << EOF
>>> todo.sh append 10 "hej!"
=== 1
10: No such task.
EOF

test_done
