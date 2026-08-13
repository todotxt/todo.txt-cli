#!/usr/bin/env bash

test_description='Bash help completion functionality

This test checks todo_completion of actions for usage help.
'
. ./actions-test-lib.sh
. ./completion-test-lib.sh
. ./test-lib.sh

make_action "zany"
make_action "aardvark"
readonly ADDONS='aardvark zany'

test_todo_completion 'all actions after help' 'todo.sh help ' "$ACTIONS $ADDONS"
test_todo_completion 'all actions after command help' 'todo.sh command help ' "$ACTIONS $ADDONS"
test_todo_completion 'actions beginning with a' 'todo.sh help a' 'add a addto addm append app archive aardvark'

test_done
