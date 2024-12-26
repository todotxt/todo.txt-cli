#!/usr/bin/env bash

make_dummy_action()
{
    local actionName; actionName="$(basename "${1:?}")"
    cat > "$1" <<EOF
#!/bin/bash
[ "\$1" = "usage" ] && {
    echo "    $actionName NR [NR ...] [TERM...]"
    echo "      This custom action does $actionName."
    echo ""
    exit
}
echo "custom action $actionName$2"
EOF
chmod +x "$1"
}

make_action()
{
    unset TODO_ACTIONS_DIR
    [ -d .todo.actions.d ] || mkdir .todo.actions.d
    [ -z "$1" ] || make_dummy_action ".todo.actions.d/$1"
}

make_action_in_folder()
{
    unset TODO_ACTIONS_DIR
    [ -d .todo.actions.d ] || mkdir .todo.actions.d
    mkdir ".todo.actions.d/$1"
    [ -z "$1" ] || make_dummy_action ".todo.actions.d/$1/$1" "in folder $1"
}

invalidate_action()
{
    local customActionFilespec="${1:?}"; shift
    local testName="${1:?}"; shift

    chmod -x "$customActionFilespec"
    # On Cygwin, clearing the executable flag may have no effect, as the Windows
    # ACL may still grant execution rights. In this case, we skip the test, and
    # remove the (still valid) custom action so that it doesn't break following
    # tests.
    if [ -x "$customActionFilespec" ]; then
        SKIP_TESTS="${SKIP_TESTS}${SKIP_TESTS+ }${testName}"
        rm -- "$customActionFilespec"
    fi
}
