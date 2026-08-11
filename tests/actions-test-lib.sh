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
    mkdir -p "$TODO_ACTIONS_DIR"
    [ -z "$1" ] || make_dummy_action "$TODO_ACTIONS_DIR/$1"
}

make_action_in_folder()
{
    mkdir -p "$TODO_ACTIONS_DIR/$1"
    [ -z "$1" ] || make_dummy_action "$TODO_ACTIONS_DIR/$1/$2" "in folder $1"
}

invalidate_action()
{
    local customActionFilespec="$TODO_ACTIONS_DIR/${1:?}"; shift

    chmod -x "$customActionFilespec"
    # On Cygwin, clearing the executable flag may have no effect, as the Windows
    # ACL may still grant execution rights. In this case, we skip the test (by
    # returning 1), and remove the (still valid) custom action so that it doesn't
    # break following tests.
    if [ -x "$customActionFilespec" ]; then
        rm -- "$customActionFilespec"
        return 1
    fi
}
