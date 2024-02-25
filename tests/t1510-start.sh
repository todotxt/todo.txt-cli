#!/bin/bash

test_description='start functionality
'
. ./test-lib.sh

#DATE=`date '+%Y-%m-%d\ %H:%M:%S'`

test_expect_success "test start command" '
        cat > todo.txt <<EOF
a
b
c
EOF
'

test_todo_session 'start command usage' <<EOF
>>> todo.sh start a b
usage: todo.sh start ITEM#[, ITEM#, ITEM#, ...]
=== 1
EOF

test_todo_session 'start missing ITEM#' <<EOF
>>> todo.sh start
usage: todo.sh start ITEM#[, ITEM#, ITEM#, ...]
=== 1
EOF

test_todo_session 'start on multiple items' <<EOF
>>> todo.sh start 1,3
1 - [$(date +'%Y-%m-%d') $(date +'%H:%M:%S')] a
TODO: 1 marked as in progress.
3 - [$(date +'%Y-%m-%d') $(date +'%H:%M:%S')] c
TODO: 3 marked as in progress.
EOF

test_todo_session 'start twice' <<EOF
>>> todo.sh start 1
TODO: 1 is already marked in progress.
EOF

test_done
