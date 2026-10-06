#!/usr/bin/env bash
#

test_description='listCustomActions() API functionality

This test covers using the listCustomActions() API to list / filter the
filespecs of available custom actions.
'
. ./actions-test-lib.sh
. ./test-lib.sh

make_action foo
make_action_in_folder check check
make_action_in_folder check chuck
make_action quux

make_action testdriver-listall '' 'listCustomActions'
test_todo_session 'add-on lists all custom actions' <<EOF
>>> todo.sh testdriver-listall
custom action testdriver-listall
check
chuck
foo
quux
testdriver-listall
EOF

make_action testdriver-filtername '' 'listCustomActions chuck'
test_todo_session 'add-on filters custom actions with static name, returns full filespec' <<EOF
>>> todo.sh testdriver-filtername
custom action testdriver-filtername
$TODO_ACTIONS_DIR/check/chuck
EOF

make_action testdriver-filterglob '' 'listCustomActions "*u*"'
test_todo_session 'add-on filters custom actions based on glob' <<EOF
>>> todo.sh testdriver-filterglob
custom action testdriver-filterglob
$TODO_ACTIONS_DIR/check/chuck
$TODO_ACTIONS_DIR/quux
EOF

make_action testdriver-filternone '' 'listCustomActions "*y*"'
test_todo_session 'add-on filters custom actions based on non-matching glob' <<EOF
>>> todo.sh testdriver-filternone
custom action testdriver-filternone
EOF

make_action testdriver-fail '' - <<'EOF'
TODO_ACTIONS_DIR=$HOME/doesNotExist
listCustomActions
EOF
test_todo_session 'add-on fails if TODO_ACTIONS_DIR does not exist' <<EOF
>>> todo.sh testdriver-fail
custom action testdriver-fail
=== 1
EOF

test_done
