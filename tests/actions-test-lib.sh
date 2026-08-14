#!/usr/bin/env bash

make_dummy_action()
{
    local actionFilespec=${1:?}; shift
    local actionName; actionName=$(basename "$actionFilespec")
    local actionContext=$1; shift || :
    cat > "$actionFilespec" <<EOF
#!/bin/bash
[ "\$1" = "usage" ] && {
    echo "    $actionName NR [NR ...] [TERM...]"
    echo "      This custom action${actionContext:+ }$actionContext does $actionName."
    echo ""
    exit
}
echo "custom action $actionName${actionContext:+ }$actionContext"
EOF
    chmod +x "$actionFilespec"
}

make_action()
{
    local actionName=$1; shift
    mkdir -p "$TODO_ACTIONS_DIR"
    [ -z "$actionName" ] || make_dummy_action "$TODO_ACTIONS_DIR/$actionName"
}

make_action_in_folder()
{
    local actionFolder=${1:?}; shift
    local actionName=$1; shift || :
    mkdir -p "$TODO_ACTIONS_DIR/$actionFolder"
    [ -z "$actionName" ] || make_dummy_action "$TODO_ACTIONS_DIR/$actionFolder/$actionName" "in folder $actionFolder"
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
