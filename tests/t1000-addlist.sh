#!/bin/sh

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
TODO: 'notice the daisies' added on line 1.

>>> todo.sh list
1 notice the daisies
--
TODO: 1 of 1 tasks shown

>>> todo.sh add smell the roses
TODO: 'smell the roses' added on line 2.

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
TODO: 'smell the uppercase Roses' added on line 3.

>>> todo.sh list roses
2 smell the roses
3 smell the uppercase Roses
--
TODO: 2 of 3 tasks shown
EOF

test_todo_session 'add with &' <<EOF
>>> todo.sh add "dig the garden & water the flowers"
TODO: 'dig the garden & water the flowers' added on line 4.

>>> todo.sh list
4 dig the garden & water the flowers
1 notice the daisies
2 smell the roses
3 smell the uppercase Roses
--
TODO: 4 of 4 tasks shown

EOF

test_done
