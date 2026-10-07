#!/usr/bin/env bash

test_description='test TODOTXT_DATE_FORMAT environment variable

Ensure that the date format of creation and completion dates is correct
'
. ./test-lib.sh


unset TODOTXT_DATE_FORMAT
test_todo_session 'default date format with env var unset' <<EOF
>>> todo.sh -t add Solve the halting problem
1 2009-02-13 Solve the halting problem
TODO: 1 added.

>>> todo.sh list
1 2009-02-13 Solve the halting problem
--
TODO: 1 of 1 tasks shown
EOF

export TODOTXT_DATE_FORMAT='%Y-%m-%dT%H:%M:%S%z'
test_todo_session 'ISO-8601 with seconds and timezone' <<EOF
>>> todo.sh -t add Solve the halting problem
2 2009-02-13T04:40:00+0000 Solve the halting problem
TODO: 2 added.

>>> todo.sh list
1 2009-02-13 Solve the halting problem
2 2009-02-13T04:40:00+0000 Solve the halting problem
--
TODO: 2 of 2 tasks shown

>>> todo.sh -t done 2
2 x 2009-02-13T04:40:00+0000 2009-02-13T04:40:00+0000 Solve the halting problem
TODO: 2 marked as done.
x 2009-02-13T04:40:00+0000 2009-02-13T04:40:00+0000 Solve the halting problem
TODO: $HOME/todo.txt archived.

>>> todo.sh list
1 2009-02-13 Solve the halting problem
--
TODO: 1 of 1 tasks shown
EOF

export TODOTXT_DATE_FORMAT='%D'
test_todo_session '%m/%d/%y completion date (with slashes)' <<EOF
>>> todo.sh -t add Solve the halting problem
2 02/13/09 Solve the halting problem
TODO: 2 added.

>>> todo.sh -t done 2
2 x 02/13/09 02/13/09 Solve the halting problem
TODO: 2 marked as done.
x 02/13/09 02/13/09 Solve the halting problem
TODO: $HOME/todo.txt archived.
EOF

export TODOTXT_DATE_FORMAT='%Y|%m|%d'
test_todo_session '%Y|%m|%d completion date (with pipe delimiters)' <<EOF
>>> todo.sh -t add Solve the halting problem
2 2009|02|13 Solve the halting problem
TODO: 2 added.

>>> todo.sh -t done 2
2 x 2009|02|13 2009|02|13 Solve the halting problem
TODO: 2 marked as done.
x 2009|02|13 2009|02|13 Solve the halting problem
TODO: $HOME/todo.txt archived.
EOF

test_done
