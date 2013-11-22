#!/bin/bash
#

test_description='Bash add-on action completion functionality

This test checks todo_completion of custom actions in .todo.actions.d
'
. ./test-lib.sh

readonly ACTIONS='add a addto addm append app archive command del rm depri dp do help list ls listaddons listall lsa listcon lsc listfile lf listpri lsp listproj lsprj move mv prepend prep pri p replace report shorthelp'
readonly OPTIONS='-@ -@@ -+ -++ -d -f -h -p -P -PP -a -n -t -v -vv -V -x'

readonly ADDONS='bar baz foobar'

readonly CONTAINED='xeno zoolander'
makeCustomActions()
{
    set -e
    mkdir "${1:?}"
    for addon in $ADDONS
    do
        addonFile="${1}/$addon"
        > "$addonFile"
        chmod +x "$addonFile"
    done

    # Also create a subdirectory, to test that it is skipped.
    mkdir "${1}/subdir"

    # Also create a non-executable file, to test that it is skipped.
    datafile="${1:?}/datafile"
    > "$datafile"
    chmod -x "$datafile"
    [ -x "$datafile" ] && rm "$datafile"    # Some file systems may always make files executable; then, skip this check.

    # Add an executable file in a folder with the same name as the file,
    # in order to ensure completion
    for contained in $CONTAINED
    do
        mkdir "${1}/$contained"
        > "${1}/$contained/$contained"
        chmod u+x "${1}/$contained/$contained"
    done

    set +e
}
removeCustomActions()
{
    set -e
    rmdir "${1}/subdir"

    for contained in $CONTAINED
    do
        rm "${1}/$contained/$contained"
        rmdir "${1}/$contained"
    done

    rm "${1:?}/"*
    rmdir "$1"
    set +e
}

#
# Test resolution of the default TODO_ACTIONS_DIR.
#
makeCustomActions "$HOME/.todo.actions.d"
test_todo_completion 'all arguments' 'todo.sh ' "$ACTIONS $ADDONS $CONTAINED $OPTIONS"
test_todo_completion 'all arguments after option' 'todo.sh -a ' "$ACTIONS $ADDONS $CONTAINED $OPTIONS"
test_todo_completion 'all arguments beginning with b' 'todo.sh b' 'bar baz'
test_todo_completion 'all arguments beginning with f after options' 'todo.sh -a -v f' 'foobar'
test_todo_completion 'nothing after addon action' 'todo.sh foobar ' ''
removeCustomActions "$HOME/.todo.actions.d"

#
# Test resolution of an alternative TODO_ACTIONS_DIR.
#
mkdir  "$HOME/.todo"
makeCustomActions "$HOME/.todo/actions"
test_todo_completion 'all arguments with actions from .todo/actions/' 'todo.sh ' "$ACTIONS $ADDONS $CONTAINED $OPTIONS"
removeCustomActions "$HOME/.todo/actions"

#
# Test resolution of a configured TODO_ACTIONS_DIR.
#
makeCustomActions "$HOME/addons"
cat >> todo.cfg <<'EOF'
export TODO_ACTIONS_DIR="$HOME/addons"
EOF
test_todo_completion 'all arguments with actions from addons/' 'todo.sh ' "$ACTIONS $ADDONS $CONTAINED $OPTIONS"
removeCustomActions "$HOME/addons"

test_done
