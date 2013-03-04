#!/bin/bash

test_description='custom actions help functionality

This test checks listing the usage help of a custom action.
'
. ./actions-test-lib.sh
. ./test-lib.sh

test_todo_session 'custom action help with no custom action directory' <<'EOF'
>>> todo.sh help foo
TODO: No action "foo" exists.
=== 1
EOF

make_action "foo"
make_action "bar"
make_action "ls"
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
TODO: No action "doesnotexist" exists.
=== 1

>>> todo.sh help foo doesnotexist bar
    foo ITEM#[, ITEM#, ...] [TERM...]
      This custom action does foo.
\
TODO: No action "doesnotexist" exists.
=== 1
EOF

test_todo_session 'mixed built-in and custom actions help' <<'EOF'
>>> todo.sh help foo shorthelp bar
    foo ITEM#[, ITEM#, ...] [TERM...]
      This custom action does foo.
\
    shorthelp
      List the one-line usage of all built-in and add-on actions.
\
    bar ITEM#[, ITEM#, ...] [TERM...]
      This custom action does bar.
\
EOF

test_todo_session 'custom override of built-in action help' <<'EOF'
>>> todo.sh help ls
    ls ITEM#[, ITEM#, ...] [TERM...]
      This custom action does ls.
\
EOF

test_done
