#!/usr/bin/env bash

test_description='custom actions functionality

This test covers the contract between todo.sh and custom actions.
'
. ./actions-test-lib.sh
. ./test-lib.sh

make_action "foo"
test_todo_session 'executable action' <<EOF
>>> todo.sh foo
custom action foo
EOF

invalidate_action .todo.actions.d/foo \
    && test_todo_session 'nonexecutable action' <<EOF
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

make_action
ln -s /actionsdir/doesnotexist/badlink .todo.actions.d/badlink
invalidate_action .todo.actions.d/badlink 2>/dev/null \
    && test_todo_session 'broken symlink' <<EOF
>>> todo.sh badlink 2>&1 | sed "s#'[^']*\(\\.todo\\.actions\\.d/[^']\{1,\}\)'#'\1'#g"
Fatal Error: Broken link to custom action: '.todo.actions.d/badlink'

>>> todo.sh do 2>/dev/null
=== 1
EOF

make_action
mkdir .todo.actions.d/badfolderlink
ln -s /actionsdir/doesnotexist/badfolderlink .todo.actions.d/badfolderlink/badfolderlink
invalidate_action .todo.actions.d/badfolderlink/badfolderlink 2>/dev/null \
    && test_todo_session 'broken symlink in folder' <<EOF
>>> todo.sh badfolderlink 2>&1 | sed "s#'[^']*\(\\.todo\\.actions\\.d/[^']\{1,\}\)'#'\1'#g"
Fatal Error: Broken link to custom action: '.todo.actions.d/badfolderlink/badfolderlink'

>>> todo.sh do 2>/dev/null
=== 1
EOF

make_action
ln -s /actionsdir/doesnotexist/do .todo.actions.d/do
invalidate_action .todo.actions.d/do 2>/dev/null \
    && test_todo_session 'broken symlink overrides built-in action' <<EOF
>>> todo.sh do 2>&1 | sed "s#'[^']*\(\\.todo\\.actions\\.d/[^']\{1,\}\)'#'\1'#g"
Fatal Error: Broken link to custom action: '.todo.actions.d/do'

>>> todo.sh do 2>/dev/null
=== 1
EOF

test_done
