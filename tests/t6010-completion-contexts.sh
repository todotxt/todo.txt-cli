#!/bin/bash
#

test_description='Bash context completion functionality

This test checks todo_completion of contexts
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
test_todo_completion 'all contexts' 'todo.sh list @' '@garden @outdoor @outside'
test_todo_completion 'contexts beginning with o' 'todo.sh list @o' '@outdoor @outside'
test_todo_completion 'contexts beginning with outs' 'todo.sh list @outs' '@outside'
test_todo_completion 'contexts beginning with x' 'todo.sh list @x' ''

test_todo_completion 'contexts from done tasks beginning with h' 'todo.sh list @h' '@home'
test_todo_completion 'contexts from done tasks beginning with or' 'todo.sh list @or' '@oriental'

test_done
