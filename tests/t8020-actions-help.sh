#!/bin/bash

test_description='actions help functionality

This test checks listing the usage help of a custom action.
'
. ./test-lib.sh

unset TODO_ACTIONS_DIR
test_todo_session 'custom action help with no custom action directory' <<'EOF'
>>> todo.sh help foo
TODO: No actions directory exists.
=== 1
EOF

mkdir .todo.actions.d
make_action()
{
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

make_action "foo"
make_action "bar"
make_action "quux"

test_todo_session 'custom action help' <<'EOF'
>>> todo.sh help foo
    foo ITEM#[, ITEM#, ...] [TERM...]
      This custom action does foo.
\

>>> todo.sh help bar
    bar ITEM#[, ITEM#, ...] [TERM...]
      This custom action does bar.
\
EOF

test_todo_session 'multiple custom actions help' <<'EOF'
>>> todo.sh help foo bar
    foo ITEM#[, ITEM#, ...] [TERM...]
      This custom action does foo.
\
    bar ITEM#[, ITEM#, ...] [TERM...]
      This custom action does bar.
\
EOF

test_todo_session 'nonexisting action help' <<'EOF'
>>> todo.sh help doesnotexist
TODO: No add-on action "doesnotexist" exists.
=== 1

>>> todo.sh help foo doesnotexist bar
    foo ITEM#[, ITEM#, ...] [TERM...]
      This custom action does foo.
\
TODO: No add-on action "doesnotexist" exists.
=== 1
EOF

test_done
