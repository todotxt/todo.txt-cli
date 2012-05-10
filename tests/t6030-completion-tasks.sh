#!/bin/bash
#

test_description='Bash task number completion functionality

This test checks todo_completion of a task number into the abbreviated task text.
'
. ./test-lib.sh

cat > todo.txt <<EOF
simple task
notice the sunflowers +sunflowers @outside @garden +shared +landscape
(B) smell the +roses flower @outside @outdoor +shared
(C) 2012-02-28 @outside mow the lawn
x 2012-02-21 +herbs @oriental buy spices
x 2012-02-28 2012-02-21 +slack @home watch tv
2012-02-28 +herbs buy cinnamon @grocer
EOF
test_todo_completion 'simple task' 'todo.sh list 1' '"1 # simple task"'
test_todo_completion 'remove projects and contents from task' 'todo.sh list 2' '"2 # notice the sunflowers"'
test_todo_completion 'keep priority' 'todo.sh list 3' '"3 # (B) smell the flower"'
test_todo_completion 'keep priority and remove timestamp' 'todo.sh list 4' '"4 # (C) mow the lawn"'
test_todo_completion 'keep done marker and remove done date' 'todo.sh list 5' '"5 # x buy spices"'
test_todo_completion 'keep done marker and remove timestamp and done date' 'todo.sh list 6' '"6 # x watch tv"'
test_todo_completion 'remove add date' 'todo.sh list 7' '"7 # buy cinnamon"'

test_done
