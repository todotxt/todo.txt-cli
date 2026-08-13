#!/usr/bin/env bash

test_description='listaddons functionality

This test checks listing of custom actions.
'
. ./actions-test-lib.sh
. ./test-lib.sh

test_todo_session 'no custom actions' <<EOF
>>> todo.sh listaddons
TODO: '$TODO_ACTIONS_DIR' does not exist.
=== 1
EOF

make_action foo
test_todo_session 'one custom action' <<EOF
>>> todo.sh listaddons
foo
--
TODO: 1 valid addon actions found.
EOF

make_action bar
make_action ls
make_action quux
test_todo_session 'multiple custom actions' <<EOF
>>> todo.sh listaddons
bar
foo
ls
quux
--
TODO: 4 valid addon actions found.
EOF

invalidate_action foo \
    && test_todo_session 'nonexecutable action' <<EOF
>>> todo.sh listaddons
bar
ls
quux
--
TODO: 3 valid addon actions found.
EOF

make_action_in_folder check check
make_action_in_folder check chuck
make_action_in_folder norris chuck
# Add a bit of cruft in the action folders in order to ensure that we only
# care about the executables with the same name as the folder in which they
# reside.
make_action_in_folder check README
invalidate_action check/README
make_action_in_folder check datafile
invalidate_action check/datafile
make_action_in_folder norris chuck
make_action_in_folder norris norris

test_todo_session 'custom actions in subfolders' <<EOF
>>> todo.sh listaddons
bar
check
chuck
ls
norris
quux
--
TODO: 6 valid addon actions found.
EOF

invalidate_action norris/norris \
    && test_todo_session 'nonexecutable action in subfolder' <<EOF
>>> todo.sh listaddons
bar
check
chuck
ls
quux
--
TODO: 5 valid addon actions found.
EOF

TODO_ACTIONS_DIR="$HOME/addons-common" make_action simple
TODO_ACTIONS_DIR="$HOME/addons-common" make_action_in_folder checker expirecheck
TODO_ACTIONS_DIR="$HOME/addons-common" make_action_in_folder checker outdatedcheck
TODO_ACTIONS_DIR="$HOME/addons-mine" make_action_in_folder wait-addon wait
TODO_ACTIONS_DIR="$HOME/addons-mine" make_action_in_folder wait-addon unwait
test_todo_session 'list custom actions from multiple actions directories' <<'EOF'
>>> TODO_ACTIONS_DIR="$HOME/addons-common:$HOME/addons-mine" todo.sh listaddons
expirecheck
outdatedcheck
simple
unwait
wait
--
TODO: 5 valid addon actions found.
EOF

test_done
