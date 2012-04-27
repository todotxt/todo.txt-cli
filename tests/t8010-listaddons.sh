#!/bin/bash

test_description='listaddons functionality

This test checks listing of custom actions.
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

test_todo_session 'no custom actions' <<EOF
>>> todo.sh listaddons
EOF

make_action "foo"
test_todo_session 'one custom action' <<EOF
>>> todo.sh listaddons
foo
EOF

make_action "bar"
make_action "ls"
make_action "quux"
test_todo_session 'multiple custom actions' <<EOF
>>> todo.sh listaddons
bar
foo
ls
quux
EOF

chmod -x .todo.actions.d/foo
# On Cygwin, clearing the executable flag may have no effect, as the Windows ACL
# may still grant execution rights. In this case, we skip the test.
if [ -x .todo.actions.d/foo ]; then
    SKIP_TESTS="${SKIP_TESTS}${SKIP_TESTS+ }t8010.4"
fi
test_todo_session 'nonexecutable action' <<EOF
>>> todo.sh listaddons
bar
ls
quux
EOF

test_done
