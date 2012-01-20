#!/bin/sh

test_description='archive functionality

Ensure we can archive items successfully.
'
. ./test-lib.sh

cat >> todo.txt<<EOF
one
two
three
one
x done
four
EOF

test_todo_session 'archive with duplicates' <<EOF
>>> todo.sh archive
x done
TODO: $HOME/todo.txt archived.
EOF

test_todo_session 'list after archive' <<EOF
>>> todo.sh ls
4 four
1 one
3 three
2 two
--
TODO: 4 of 4 tasks shown
EOF

test_done
