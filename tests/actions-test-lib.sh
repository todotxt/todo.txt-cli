#!/bin/bash

make_dummy_action()
{
    local actionName; actionName="$(basename "${1:?}")"
    cat > "$1" <<EOF
#!/bin/bash
[ "\$1" = "usage" ] && {
    echo "    $actionName ITEM#[, ITEM#, ...] [TERM...]"
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
    make_dummy_action ".todo.actions.d/$1"
}

make_action_in_folder()
{
    unset TODO_ACTIONS_DIR
    [ -d .todo.actions.d ] || mkdir .todo.actions.d
    mkdir ".todo.actions.d/$1"
    make_dummy_action ".todo.actions.d/$1/$1" "in folder $1"
}
