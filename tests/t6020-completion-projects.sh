#!/bin/bash
#

test_description='Bash project completion functionality

This test checks todo_completion of projects
'
. ./test-lib.sh

cat > todo.txt <<EOF
(B) smell the +roses @outside @outdoor +shared
notice the sunflowers +sunflowers @outside @garden +shared +landscape
stop
EOF
cat > done.txt <<EOF
x 2012-02-21 +herbs @oriental buy spices
x 2012-02-21 +slack @home watch tv
EOF
test_todo_completion 'all projects' 'todo.sh list +' '+landscape +roses +shared +sunflowers'
test_todo_completion 'projects beginning with s' 'todo.sh list +s' '+shared +sunflowers'
test_todo_completion 'projects beginning with ro' 'todo.sh list +ro' '+roses'
test_todo_completion 'projects beginning with x' 'todo.sh list +x' ''

test_todo_completion 'projects from done tasks beginning with h' 'todo.sh list +h' '+herbs'
test_todo_completion 'projects from done tasks beginning with sl' 'todo.sh list +sl' '+slack'

test_done
