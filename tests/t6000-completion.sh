#!/usr/bin/env bash

test_description='Bash completion functionality

This test checks basic todo_completion of actions and options
'
. ./completion-test-lib.sh
. ./test-lib.sh

test_todo_completion 'all arguments' 'todo.sh ' "$ACTIONS $OPTIONS"
test_todo_completion 'arguments beginning with a' 'todo.sh a' 'add a addto addm append app archive'
test_todo_completion 'all options' 'todo.sh -' "$OPTIONS"
test_todo_completion 'all actions after command action' 'todo.sh command ' "$ACTIONS"
test_todo_completion 'all arguments after option' 'todo.sh -a ' "$ACTIONS $OPTIONS"
test_todo_completion 'all arguments after options' 'todo.sh -a -p ' "$ACTIONS $OPTIONS"
test_todo_completion 'all options after options' 'todo.sh -a -p -' "$OPTIONS"
test_todo_completion 'nothing after action' 'todo.sh archive ' ''

test_done
