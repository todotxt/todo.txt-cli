#!/usr/bin/env bash
#

test_description='override of TODO_FILE config location

This test ensures that the TODO_FILE config location can be overridden via
environment variable.
'
. ./test-lib.sh

test_todo_session 'add/list with override' <<EOF
>>> todo.sh add notice the daisies
1 notice the daisies
TODO: 1 added.

>>> todo.sh list
1 notice the daisies
--
TODO: 1 of 1 tasks shown

>>> TODO_FILE="$HOME/special.txt" todo.sh add smell the roses
1 smell the roses
SPECIAL: 1 added.

>>> todo.sh list
1 notice the daisies
--
TODO: 1 of 1 tasks shown

>>> TODO_FILE="$HOME/special.txt" todo.sh list
1 smell the roses
--
SPECIAL: 1 of 1 tasks shown
EOF

test_todo_session 'do with override' <<EOF
>>> DONE_FILE="$HOME/specialdone.txt" todo.sh do 1
1 x 2009-02-13 notice the daisies
TODO: 1 marked as done.
x 2009-02-13 notice the daisies
TODO: $HOME/todo.txt archived.

>>> TODO_FILE="$HOME/special.txt" DONE_FILE="$HOME/specialdone.txt" todo.sh do 1
1 x 2009-02-13 smell the roses
TODO: 1 marked as done.
x 2009-02-13 smell the roses
TODO: $HOME/special.txt archived.

>>> todo.sh -p listfile specialdone.txt
1 x 2009-02-13 notice the daisies
2 x 2009-02-13 smell the roses
--
SPECIALDONE: 2 of 2 tasks shown
EOF

test_done
