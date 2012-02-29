#!/bin/bash
#

test_description='Bash completion with different aliases functionality

This test checks that todo_completion can use a different configuration
when another todo.sh alias is defined that uses that configuration.
'
. ./test-lib.sh

cat > todo.txt <<EOF
(B) smell the +roses @outside @outdoor +shared
notice the sunflowers +sunflowers @outside @garden +shared +landscape
stop
EOF
cat > todo2.txt <<EOF
+herbs @oriental buy spices
+slack @home watch tv
EOF

cp todo.cfg todo2.cfg
cat >> todo2.cfg <<'EOF'
export TODO_FILE="$TODO_DIR/todo2.txt"
EOF

# Note: We cannot use aliases within the test framework, but functions are
# equivalent and work fine.
todo1()
{
    todo.sh "$@"
}
todo2()
{
    todo.sh -d "$HOME/todo2.cfg" "$@"
}

# Ensure that the test fixture works as planned.
test_todo_session 'todo 1 and 2 contexts' <<EOF
>>> todo1 listcon
@garden
@outdoor
@outside

>>> todo2 listcon
@home
@oriental
EOF


# Define a second completion function that injects the different configuration
# file. In real use, this would be installed via
#   complete -F _todo2 todo2
_todo2()
{
    local _todo_sh='todo.sh -d "$HOME/todo2.cfg"'
    _todo "$@"
}

test_todo_completion               'all todo1 contexts' 'todo1 list @' '@garden @outdoor @outside'
test_todo_custom_completion _todo2 'all todo2 contexts' 'todo2 list @' '@home @oriental'

test_done
