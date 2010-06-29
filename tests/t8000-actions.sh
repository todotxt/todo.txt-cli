#!/bin/sh

test_description='custom actions functionality

This test covers the contract between todo.sh and custom actions.
'
. ./test-lib.sh

unset TODO_ACTIONS_DIR
mkdir .todo.actions.d
cat > .todo.actions.d/foo << EOF
echo "TODO: foo"
EOF

test_todo_session 'nonexecutable action' <<EOF
>>> todo.sh foo
Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
Try 'todo.sh -h' for more information.
=== 1
EOF

chmod +x .todo.actions.d/foo
test_todo_session 'executable action' <<EOF
>>> todo.sh foo
TODO: foo
EOF

cat > .todo.actions.d/ls << EOF
echo "TODO: my ls"
EOF
chmod +x .todo.actions.d/ls
test_todo_session 'overriding built-in action' <<EOF
>>> todo.sh ls
TODO: my ls

>>> todo.sh command ls
--
TODO: 0 of 0 tasks shown
EOF

cat > .todo.actions.d/bad << EOF
echo "TODO: bad"
exit 42
EOF
chmod +x .todo.actions.d/bad
test_todo_session 'failing action' <<EOF
>>> todo.sh bad
TODO: bad
=== 42
EOF

test_done
