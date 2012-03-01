#!/bin/bash
#

test_description='Bash completion with different path functionality

This test checks that todo_completion can use a different path to todo.sh when
it is not accessible through PATH.
'
. ./test-lib.sh

cat > todo.txt <<EOF
(B) smell the +roses @outside @outdoor +shared
notice the sunflowers +sunflowers @outside @garden +shared +landscape
stop
EOF

mv bin/todo.sh bin/todo2.sh
test_expect_success 'todo2.sh executable' 'todo2.sh list'

# Define a second completion function that injects the different executable. In
# real use, this would be installed via
#   complete -F _todo2 todo2.sh
_todo2()
{
    local _todo_sh='todo2.sh'
    _todo "$@"
}

test_todo_custom_completion _todo2 'all todo2 contexts' 'todo2 list @' '@garden @outdoor @outside'



# Remove the test environment's bin directory from the PATH, so that our test
# executable must be launched with an explicit path.
PATH=${PATH##"${PWD}/bin:"}
test_expect_code 127 'todo2.sh executable not in PATH' 'todo2.sh'

_todo2path()
{
    local _todo_sh='./bin/todo2.sh'
    _todo "$@"
}
test_todo_custom_completion _todo2path 'all todo2 contexts' 'todo2 list @' '@garden @outdoor @outside'

test_done
