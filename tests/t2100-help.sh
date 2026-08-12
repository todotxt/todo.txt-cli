#!/usr/bin/env bash

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

make_action foo
make_action bar
make_action ls
make_action quux
make_action_in_folder check check
make_action_in_folder check chuck
make_action_in_folder norris actionhero
make_action_in_folder norris chuck
make_action_in_folder norris norris
test_todo_session 'help output with custom action' <<EOF
>>> todo.sh -v help | sed '/^  [A-Z]/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Options:
  Built-in Actions:
  Add-on Actions:
EOF

test_todo_session 'help output with custom action lists all available custom actions alphabetically' <<'EOF'
>>> todo.sh listaddons
actionhero
bar
check
chuck
foo
ls
norris
quux
--
TODO: 8 valid addon actions found.

>>> todo.sh -v help | sed -n '/^  Add-on Actions:/,/^  [A-Z]/p'
  Add-on Actions:
    actionhero NR [NR ...] [TERM...]
      This custom action in folder norris does actionhero.
\
    bar NR [NR ...] [TERM...]
      This custom action does bar.
\
    check NR [NR ...] [TERM...]
      This custom action in folder check does check.
\
    chuck NR [NR ...] [TERM...]
      This custom action in folder check does chuck.
\
    foo NR [NR ...] [TERM...]
      This custom action does foo.
\
    ls NR [NR ...] [TERM...]
      This custom action does ls.
\
    norris NR [NR ...] [TERM...]
      This custom action in folder norris does norris.
\
    quux NR [NR ...] [TERM...]
      This custom action does quux.
\
EOF

test_done
