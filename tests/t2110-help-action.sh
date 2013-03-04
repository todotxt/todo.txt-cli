#!/bin/bash

test_description='built-in actions help functionality

This test checks listing the usage help of a built-in action.
'
. ./test-lib.sh

test_todo_session 'nonexisting action help' <<'EOF'
>>> todo.sh help doesnotexist
TODO: No action "doesnotexist" exists.
=== 1

>>> todo.sh help hel
TODO: No action "hel" exists.
=== 1

>>> todo.sh help h
TODO: No action "h" exists.
=== 1
EOF

test_todo_session 'single action help' <<'EOF'
>>> todo.sh help shorthelp
    shorthelp
      List the one-line usage of all built-in and add-on actions.
\
EOF

test_todo_session 'multiple actions help' <<'EOF'
>>> todo.sh help shorthelp append
    shorthelp
      List the one-line usage of all built-in and add-on actions.
\
    append ITEM# "TEXT TO APPEND"
    app ITEM# "TEXT TO APPEND"
      Adds TEXT TO APPEND to the end of the task on line ITEM#.
      Quotes optional.
\
EOF

test_todo_session 'short and long form of action help' <<'EOF'
>>> todo.sh help append
    append ITEM# "TEXT TO APPEND"
    app ITEM# "TEXT TO APPEND"
      Adds TEXT TO APPEND to the end of the task on line ITEM#.
      Quotes optional.
\

>>> todo.sh help app
    app ITEM# "TEXT TO APPEND"
      Adds TEXT TO APPEND to the end of the task on line ITEM#.
      Quotes optional.
\
EOF

test_todo_session 'mixed existing and nonexisting action help' <<'EOF'
>>> todo.sh help shorthelp doesnotexist list
    shorthelp
      List the one-line usage of all built-in and add-on actions.
\
TODO: No action "doesnotexist" exists.
=== 1
EOF

test_done
