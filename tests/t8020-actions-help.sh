#!/bin/bash

test_description='actions help functionality

This test checks listing the usage help of a custom action.
'
. ./actions-test-lib.sh
. ./test-lib.sh

test_todo_session 'custom action help with no custom action directory' <<'EOF'
>>> todo.sh help foo
TODO: No actions directory exists.
=== 1
EOF

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
