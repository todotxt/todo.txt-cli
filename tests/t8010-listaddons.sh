#!/bin/bash

test_description='listaddons functionality

This test checks listing of custom actions.
'
. ./actions-test-lib.sh
. ./test-lib.sh

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
