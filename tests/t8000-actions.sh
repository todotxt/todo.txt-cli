#!/bin/sh

test_description='custom actions functionality

This test covers the contract between todo.sh and custom actions.
'
. ./test-lib.sh

unset TODO_ACTIONS_DIR
mkdir .todo.actions.d
make_action()
{
	cat > ".todo.actions.d/$1" <<- EOF
	#!/bin/bash
	echo "custom action $1"
EOF
chmod +x ".todo.actions.d/$1"
}

make_action "foo"
test_todo_session 'executable action' <<EOF
>>> todo.sh foo
custom action foo
EOF

chmod -x .todo.actions.d/foo
# On Cygwin, clearing the executable flag may have no effect, as the Windows ACL
# may still grant execution rights. In this case, we skip the test.
if [ -x .todo.actions.d/foo ]; then
    SKIP_TESTS="${SKIP_TESTS}${SKIP_TESTS+ }t8000.2"
fi
test_todo_session 'nonexecutable action' <<EOF
>>> todo.sh foo
Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
Try 'todo.sh -h' for more information.
=== 1
EOF

make_action "ls"
test_todo_session 'overriding built-in action' <<EOF
>>> todo.sh ls
custom action ls

>>> todo.sh command ls
--
TODO: 0 of 0 tasks shown
EOF

make_action "bad"
echo "exit 42" >> .todo.actions.d/bad
test_todo_session 'failing action' <<EOF
>>> todo.sh bad
custom action bad
=== 42
EOF

test_done
