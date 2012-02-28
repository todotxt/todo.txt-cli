#!/bin/bash
#

test_description='Bash completion functionality

This test checks basic todo_completion of actions and options
'
. ./test-lib.sh

readonly ACTIONS='add a addto addm append app archive command del rm depri dp do help list ls listaddons listall lsa listcon lsc listfile lf listpri lsp listproj lsprj move mv prepend prep pri p replace report shorthelp'
readonly OPTIONS='-@ -@@ -+ -++ -d -f -h -p -P -PP -a -n -t -v -vv -V -x'

test_todo_completion 'all arguments' 'todo.sh ' "$ACTIONS $OPTIONS"
test_todo_completion 'arguments beginning with a' 'todo.sh a' 'add a addto addm append app archive'
test_todo_completion 'all options' 'todo.sh -' "$OPTIONS"
test_todo_completion 'all actions after command action' 'todo.sh command ' "$ACTIONS"
test_todo_completion 'all arguments after option' 'todo.sh -a ' "$ACTIONS $OPTIONS"
test_todo_completion 'all arguments after options' 'todo.sh -a -p ' "$ACTIONS $OPTIONS"
test_todo_completion 'all options after options' 'todo.sh -a -p -' "$OPTIONS"
test_todo_completion 'nothing after action' 'todo.sh archive ' ''

test_done
