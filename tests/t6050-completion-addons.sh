#!/usr/bin/env bash

test_description='Bash add-on action completion functionality

This test checks todo_completion of custom actions in .todo.actions.d
'
. ./actions-test-lib.sh
. ./completion-test-lib.sh
. ./test-lib.sh

ADDONS='bar baz foobar'
CONTAINED='xeno zoolander'

makeCustomActions()
{
    local actionsDir="${1:?}"
    local TODO_ACTIONS_DIR="$actionsDir"
    set -e
    for addon in $ADDONS
    do
         make_action "$addon"
    done

    # Also create a subdirectory, to test that it is skipped.
    mkdir -p "$actionsDir/subdir"

    # Also create a non-executable file, to test that it is skipped.
    make_action datafile
    invalidate_action datafile  # Note: Some file systems may always make files executable; then, the file is removed, effectively skipping this check.

    # Add an executable file in a folder with the same name as the file,
    # in order to ensure completion
    for contained in $CONTAINED
    do
        make_action_in_folder container "$contained"
    done

    set +e
}
removeCustomActions()
{
    local actionsDir="${1:?}"
    set -e
    rmdir "$actionsDir/subdir"

    local hasContainer
    for contained in $CONTAINED
    do
        rm "$actionsDir/container/$contained"
        hasContainer=t
    done
    [ "$hasContainer" ] && rmdir "$actionsDir/container"

    rm "$actionsDir/"*
    rmdir "$actionsDir"
    set +e
}

#
# Test resolution of the default location 1 TODO_ACTIONS_DIR.
#
defaultActionsDir="$TODO_ACTIONS_DIR"
unset TODO_ACTIONS_DIR
makeCustomActions "$defaultActionsDir"
test_todo_completion 'all arguments' 'todo.sh ' "$ACTIONS $ADDONS $CONTAINED $OPTIONS"
test_todo_completion 'all arguments after option' 'todo.sh -a ' "$ACTIONS $ADDONS $CONTAINED $OPTIONS"
test_todo_completion 'all arguments beginning with b' 'todo.sh b' 'bar baz'
test_todo_completion 'all arguments beginning with f after options' 'todo.sh -a -v f' 'foobar'
test_todo_completion 'nothing after addon action' 'todo.sh foobar ' ''
removeCustomActions "$defaultActionsDir"

#
# Test resolution of the default location 2 TODO_ACTIONS_DIR.
#
makeCustomActions "$HOME/.todo.actions.d"
test_todo_completion 'all arguments with actions from .todo/actions/' 'todo.sh ' "$ACTIONS $ADDONS $CONTAINED $OPTIONS"
removeCustomActions "$HOME/.todo.actions.d"

#
# Test resolution of a configured TODO_ACTIONS_DIR.
#
makeCustomActions "$HOME/addons"
cat >> todo.cfg <<'EOF'
export TODO_ACTIONS_DIR="$HOME/addons"
EOF
test_todo_completion 'all arguments with actions from addons/' 'todo.sh ' "$ACTIONS $ADDONS $CONTAINED $OPTIONS"
removeCustomActions "$HOME/addons"

#
# Test resolution of multiple TODO_ACTIONS_DIR base directories.
#
CONTAINED='' makeCustomActions "$HOME/addons-direct"
ADDONS='' makeCustomActions "$HOME/addons-contained"
cat >> todo.cfg <<'EOF'
export TODO_ACTIONS_DIR="$HOME/addons-direct:$HOME/addons-contained"
EOF
test_todo_completion 'all arguments with actions from both addons-direct and addons-contained' 'todo.sh ' "$ACTIONS $ADDONS $CONTAINED $OPTIONS"
CONTAINED='' removeCustomActions "$HOME/addons-direct"
ADDONS='' removeCustomActions "$HOME/addons-contained"

test_done
