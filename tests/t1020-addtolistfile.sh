#!/bin/bash

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
=== 1
EOF

touch "$HOME/garden.txt"

test_todo_session 'basic addto/listfile' <<EOF
>>> todo.sh addto garden.txt notice the daisies
1 notice the daisies
GARDEN: 1 added.

>>> todo.sh listfile garden.txt
1 notice the daisies
--
GARDEN: 1 of 1 tasks shown

>>> todo.sh addto garden.txt smell the roses
2 smell the roses
GARDEN: 2 added.

>>> todo.sh listfile garden.txt
1 notice the daisies
2 smell the roses
--
GARDEN: 2 of 2 tasks shown
EOF

#
# List available files
#
test_todo_session 'list available files' <<EOF
>>> todo.sh listfile
Files in the todo.txt directory:
done.txt
garden.txt
report.txt
todo.txt

>>> TODOTXT_VERBOSE=0 todo.sh listfile
done.txt
garden.txt
report.txt
todo.txt
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
3 smell the uppercase Roses
GARDEN: 3 added.

>>> todo.sh listfile garden.txt roses
2 smell the roses
3 smell the uppercase Roses
--
GARDEN: 2 of 3 tasks shown
EOF

test_todo_session 'addto with &' <<EOF
>>> todo.sh addto garden.txt "dig the garden & water the flowers"
4 dig the garden & water the flowers
GARDEN: 4 added.

>>> todo.sh listfile garden.txt 
4 dig the garden & water the flowers
1 notice the daisies
2 smell the roses
3 smell the uppercase Roses
--
GARDEN: 4 of 4 tasks shown
EOF

test_done
