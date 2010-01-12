#!/bin/sh

test_description='basic addto and list functionality

This test just makes sure the basic addto and listfile
commands work, including support for filtering.
'
. ./test-lib.sh

#
# Addto and listfile
#
test_todo_session 'nonexistant file' <<EOF
>>> todo.sh addto garden.txt notice the daisies
TODO: Destination file $HOME/garden.txt does not exist.
EOF

touch "$HOME/garden.txt"

test_todo_session 'basic addto/listfile' <<EOF
>>> todo.sh addto garden.txt notice the daisies
GARDEN: 'notice the daisies' added on line 1.

>>> todo.sh listfile garden.txt
1 notice the daisies
--
GARDEN: 1 of 1 tasks shown

>>> todo.sh addto garden.txt smell the roses
GARDEN: 'smell the roses' added on line 2.

>>> todo.sh listfile garden.txt
1 notice the daisies
2 smell the roses
--
GARDEN: 2 of 2 tasks shown
EOF

#
# Filter
#
test_todo_session 'basic listfile filtering' <<EOF
>>> todo.sh listfile garden.txt daisies
1 notice the daisies
--
GARDEN: 1 of 2 tasks shown

>>> todo.sh listfile garden.txt smell  
2 smell the roses
--
GARDEN: 1 of 2 tasks shown
EOF

test_todo_session 'case-insensitive filtering' <<EOF
>>> todo.sh addto garden.txt smell the uppercase Roses
GARDEN: 'smell the uppercase Roses' added on line 3.

>>> todo.sh listfile garden.txt roses
2 smell the roses
3 smell the uppercase Roses
--
GARDEN: 2 of 3 tasks shown
EOF

test_todo_session 'addto with &' <<EOF
>>> todo.sh addto garden.txt "dig the garden & water the flowers"
GARDEN: 'dig the garden & water the flowers' added on line 4.

>>> todo.sh listfile garden.txt 
4 dig the garden & water the flowers
1 notice the daisies
2 smell the roses
3 smell the uppercase Roses
--
GARDEN: 4 of 4 tasks shown
EOF

test_done
