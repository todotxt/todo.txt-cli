#!/bin/bash

make_action()
{
    unset TODO_ACTIONS_DIR
    [ -d .todo.actions.d ] || mkdir .todo.actions.d
    cat > ".todo.actions.d/$1" <<EOF
#!/bin/bash
[ "\$1" = "usage" ] && {
    echo "    $1 ITEM#[, ITEM#, ...] [TERM...]"
    echo "      This custom action does $1."
    echo ""
    exit
}
echo "custom action $1"
EOF
chmod +x ".todo.actions.d/$1"
}
