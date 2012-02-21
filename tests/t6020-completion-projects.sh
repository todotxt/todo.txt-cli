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
test_todo_completion 'all projects' 'todo.sh list +' '+landscape +roses +shared +sunflowers'
test_todo_completion 'projects beginning with s' 'todo.sh list +s' '+shared +sunflowers'
test_todo_completion 'projects beginning with ro' 'todo.sh list +ro' '+roses'
test_todo_completion 'projects beginning with x' 'todo.sh list +x' ''

test_done
