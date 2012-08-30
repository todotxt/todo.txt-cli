#!/bin/bash
#

test_description='shorthelp functionality

This test covers the output of the -h option and the shorthelp action.
'
. ./actions-test-lib.sh
. ./test-lib.sh

# Note: To avoid having to adapt the test whenever the actions change, only
# check for the section headers.
test_todo_session '-h output' <<EOF
>>> todo.sh -h | sed '/^  [A-Z]/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Actions:
  Actions can be added and overridden using scripts in the actions
  See "help" for more details.
EOF

test_todo_session 'shorthelp output' <<EOF
>>> todo.sh shorthelp | sed '/^  [A-Z]/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Actions:
  Actions can be added and overridden using scripts in the actions
  See "help" for more details.
EOF

make_action "foo"
test_todo_session 'shorthelp output with custom action' <<EOF
>>> todo.sh -v shorthelp | sed '/^  [A-Z]/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Actions:
  Actions can be added and overridden using scripts in the actions
  Add-on Actions:
  See "help" for more details.
EOF

test_done
