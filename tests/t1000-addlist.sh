#!/bin/bash

test_description='basic add and list functionality

This test just makes sure the basic add and list
command work, including support for filtering.
'
. ./test-lib.sh

#
# Add and list
#
test_todo_session 'basic add/list' <<EOF
>>> todo.sh add notice the daisies
1 notice the daisies
TODO: 1 added.

>>> todo.sh list
1 notice the daisies
--
TODO: 1 of 1 tasks shown

>>> todo.sh add smell the roses
2 smell the roses
TODO: 2 added.

>>> todo.sh list
1 notice the daisies
2 smell the roses
--
TODO: 2 of 2 tasks shown
EOF

#
# Filter
#
test_todo_session 'basic list filtering' <<EOF
>>> todo.sh list daisies
1 notice the daisies
--
TODO: 1 of 2 tasks shown

>>> todo.sh list smell
2 smell the roses
--
TODO: 1 of 2 tasks shown
EOF

test_todo_session 'case-insensitive filtering' <<EOF
>>> todo.sh add smell the uppercase Roses
3 smell the uppercase Roses
TODO: 3 added.

>>> todo.sh list roses
2 smell the roses
3 smell the uppercase Roses
--
TODO: 2 of 3 tasks shown
EOF

test_todo_session 'add with symbols' <<EOF
>>> todo.sh add "~@#$%^&*()-_=+[{]}|;:',<.>/?"
4 ~@#$%^&*()-_=+[{]}|;:',<.>/?
TODO: 4 added.

>>> todo.sh add '\`!\\"'
5 \`!\\"
TODO: 5 added.

>>> todo.sh list
1 notice the daisies
2 smell the roses
3 smell the uppercase Roses
5 \`!\\"
4 ~@#$%^&*()-_=+[{]}|;:',<.>/?
--
TODO: 5 of 5 tasks shown
EOF

#
# Advanced add
#

cat /dev/null > todo.txt
test_todo_session 'add with spaces' <<EOF
>>> todo.sh add "notice the   three   spaces"
1 notice the   three   spaces
TODO: 1 added.

>>> todo.sh add notice how the   spaces    get lost
2 notice how the spaces get lost
TODO: 2 added.

>>> todo.sh list
2 notice how the spaces get lost
1 notice the   three   spaces
--
TODO: 2 of 2 tasks shown
EOF

cat /dev/null > todo.txt
test_todo_session 'add with CR' <<EOF
>>> todo.sh add "smell theCarriage Return"
1 smell the Carriage Return
TODO: 1 added.

>>> todo.sh list
1 smell the Carriage Return
--
TODO: 1 of 1 tasks shown
EOF

test_done
