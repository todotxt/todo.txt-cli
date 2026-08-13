#!/usr/bin/env bash

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

make_action foo
make_action bar
make_action ls
make_action quux

test_todo_session 'custom action help' <<'EOF'
>>> todo.sh help foo
    foo NR [NR ...] [TERM...]
      This custom action does foo.
\

>>> todo.sh help bar
    bar NR [NR ...] [TERM...]
      This custom action does bar.
\
EOF

make_action_in_folder check check
make_action_in_folder check chuck
make_action_in_folder norris chuck
make_action_in_folder norris norris
test_todo_session 'custom action in subfolders help' <<'EOF'
>>> todo.sh help check
    check NR [NR ...] [TERM...]
      This custom action in folder check does check.
\

>>> todo.sh help chuck
    chuck NR [NR ...] [TERM...]
      This custom action in folder check does chuck.
\

>>> todo.sh help norris
    norris NR [NR ...] [TERM...]
      This custom action in folder norris does norris.
\
EOF

test_todo_session 'multiple custom actions help' <<'EOF'
>>> todo.sh help foo bar
    foo NR [NR ...] [TERM...]
      This custom action does foo.
\
    bar NR [NR ...] [TERM...]
      This custom action does bar.
\
EOF

test_todo_session 'nonexisting action help' <<'EOF'
>>> todo.sh help doesnotexist
TODO: No action "doesnotexist" exists.
=== 1

>>> todo.sh help foo doesnotexist bar
    foo NR [NR ...] [TERM...]
      This custom action does foo.
\
TODO: No action "doesnotexist" exists.
=== 1
EOF

test_todo_session 'mixed built-in and custom actions help' <<'EOF'
>>> todo.sh help foo shorthelp bar
    foo NR [NR ...] [TERM...]
      This custom action does foo.
\
    shorthelp
      List the one-line usage of all built-in and add-on actions.
\
    bar NR [NR ...] [TERM...]
      This custom action does bar.
\
EOF

test_todo_session 'custom override of built-in action help' <<'EOF'
>>> todo.sh help ls
    ls NR [NR ...] [TERM...]
      This custom action does ls.
\
EOF

TODO_ACTIONS_DIR="$HOME/projects/addons-wait" make_action wait
TODO_ACTIONS_DIR="$HOME/projects/addons-wait" make_action unwait
TODO_ACTIONS_DIR="$HOME/addons-common" make_action_in_folder checker expirecheck
TODO_ACTIONS_DIR="$HOME/addons-common" make_action_in_folder checker outdatedcheck
test_todo_session 'custom action help from multiple actions directories' <<'EOF'
>>> TODO_ACTIONS_DIR="$HOME/addons-common:$HOME/projects/addons-wait" todo.sh help expirecheck
    expirecheck NR [NR ...] [TERM...]
      This custom action in folder checker does expirecheck.
\

>>> TODO_ACTIONS_DIR="$HOME/addons-common:$HOME/projects/addons-wait" todo.sh help unwait
    unwait NR [NR ...] [TERM...]
      This custom action does unwait.
\
EOF

test_done
