#!/bin/bash
#

test_description='help functionality

This test covers the help output.
'
. ./actions-test-lib.sh
. ./test-lib.sh

# Note: To avoid having to adapt the test whenever the help documentation
# slightly changes, only check for the section headers.
test_todo_session 'help output' <<EOF
>>> todo.sh help | sed '/^  [A-Z]/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Options:
  Built-in Actions:
EOF

test_todo_session 'verbose help output' <<EOF
>>> todo.sh -v help | sed '/^  [A-Z]/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Options:
  Built-in Actions:
EOF

test_todo_session 'very verbose help output' <<EOF
>>> todo.sh -vv help | sed '/^  [A-Z]/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Options:
  Environment variables:
  Built-in Actions:
EOF

make_action "foo"
test_todo_session 'help output with custom action' <<EOF
>>> todo.sh -v help | sed '/^  [A-Z]/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Options:
  Built-in Actions:
  Add-on Actions:
EOF

test_done
