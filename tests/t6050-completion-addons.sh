#!/bin/bash
#

test_description='Bash add-on action completion functionality

This test checks todo_completion of custom actions in .todo.actions.d
'
. ./test-lib.sh

readonly ACTIONS='add a addto addm append app archive command del rm depri dp do help list ls listall lsa listcon lsc listfile lf listpri lsp listproj lsprj move mv prepend prep pri p replace report shorthelp'
readonly OPTIONS='-@ -@@ -+ -++ -d -f -h -p -P -PP -a -n -t -v -vv -V -x'

readonly ADDONS='bar baz foobar'
mkdir "$HOME/.todo.actions.d"
for addon in $ADDONS
do
    > "$HOME/.todo.actions.d/$addon"
    chmod +x "$HOME/.todo.actions.d/$addon"
done
test_todo_completion 'all arguments' 'todo.sh ' "$ACTIONS $ADDONS $OPTIONS"
test_todo_completion 'all arguments after option' 'todo.sh -a ' "$ACTIONS $ADDONS $OPTIONS"
test_todo_completion 'all arguments beginning with b' 'todo.sh b' 'bar baz'
test_todo_completion 'all arguments beginning with f after options' 'todo.sh -a -v f' 'foobar'
test_todo_completion 'nothing after addon action' 'todo.sh foobar ' ''

test_done
