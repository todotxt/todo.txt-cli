#!/usr/bin/env bash

test_description='custom actions functionality

This test covers the contract between todo.sh and custom actions.
'
. ./actions-test-lib.sh
. ./test-lib.sh

make_action foo
test_todo_session 'executable action' <<EOF
>>> todo.sh foo
custom action foo
EOF

invalidate_action foo \
    && test_todo_session 'nonexecutable action' <<EOF
>>> todo.sh foo
Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
Try 'todo.sh -h' for more information.
=== 1
EOF

make_action ls
test_todo_session 'overriding built-in action' <<EOF
>>> todo.sh ls
custom action ls

>>> todo.sh command ls
--
TODO: 0 of 0 tasks shown
EOF

make_action_in_folder check check
make_action_in_folder check chuck
make_action_in_folder norris chuck
make_action_in_folder norris norris
test_todo_session 'executable actions in subfolders takes first folder' <<EOF
>>> todo.sh check
custom action check in folder check

>>> todo.sh chuck
custom action chuck in folder check

>>> todo.sh norris
custom action norris in folder norris
EOF

make_action chuck
test_todo_session 'executable action in subfolder takes precendence over same action in actions dir' <<EOF
>>> todo.sh chuck
custom action chuck in folder check
EOF

make_action bad
echo "exit 42" >> "$TODO_ACTIONS_DIR/bad"
test_todo_session 'failing action' <<EOF
>>> todo.sh bad
custom action bad
=== 42
EOF

make_action
ln -s /actionsdir/doesnotexist/badlink "$TODO_ACTIONS_DIR/badlink"
invalidate_action badlink 2>/dev/null \
    && test_todo_session 'broken symlink' <<EOF
>>> todo.sh badlink
=== 1
Fatal Error: Broken link to custom action: '$TODO_ACTIONS_DIR/badlink'
EOF

make_action
mkdir "$TODO_ACTIONS_DIR/badfolderlink"
ln -s /actionsdir/doesnotexist/badfolderlink "$TODO_ACTIONS_DIR/badfolderlink/badfolderlink"
invalidate_action badfolderlink/badfolderlink 2>/dev/null \
    && test_todo_session 'broken symlink in folder' <<EOF
>>> todo.sh badfolderlink
=== 1
Fatal Error: Broken link to custom action: '$TODO_ACTIONS_DIR/badfolderlink/badfolderlink'
EOF

make_action
ln -s /actionsdir/doesnotexist/do "$TODO_ACTIONS_DIR/do"
invalidate_action do 2>/dev/null \
    && test_todo_session 'broken symlink overrides built-in action' <<EOF
>>> todo.sh do
=== 1
Fatal Error: Broken link to custom action: '$TODO_ACTIONS_DIR/do'
EOF

test_done
