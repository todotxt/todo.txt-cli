#!/bin/sh

test_description='archive functionality

Ensure we can append items successfully.
'
. ./test-lib.sh

cat >> todo.txt<<EOF
x smell them quietly
EOF

test_todo_session 'archive lowercase x' <<EOF
>>> todo.sh archive
x smell them quietly
TODO: $HOME/todo.txt archived.
EOF

cat > todo.txt <<EOF
notice the daisies
X smell the roses
EOF

test_todo_session 'archive uppercase X' <<EOF
>>> todo.sh archive
X smell the roses
TODO: $HOME/todo.txt archived.
EOF

test_done
