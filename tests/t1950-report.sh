#!/bin/bash

test_description='report functionality

This test checks the reporting and the format of the report file.
'
. ./test-lib.sh

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
stop and think
smell the coffee +wakeup
make the coffee +wakeup
visit http://example.com
EOF

test_todo_session 'create new report' <<EOF
>>> todo.sh report
TODO: $HOME/todo.txt archived.
2009-02-13T04:40:00 5 0
TODO: Report file updated.

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
4 make the coffee +wakeup
3 smell the coffee +wakeup
2 stop and think
5 visit http://example.com
--
TODO: 5 of 5 tasks shown
EOF

test_todo_session 'report of done tasks' <<EOF
>>> todo.sh -A do 3
3 x 2009-02-13 smell the coffee +wakeup
TODO: 3 marked as done.
x 2009-02-13 smell the coffee +wakeup
TODO: $HOME/todo.txt archived.

>>> todo.sh report
TODO: $HOME/todo.txt archived.
2009-02-13T04:40:00 4 1
TODO: Report file updated.

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
3 make the coffee +wakeup
2 stop and think
4 visit http://example.com
--
TODO: 4 of 4 tasks shown
EOF

test_todo_session 'report performs archiving' <<EOF
>>> todo.sh -a do 3
3 x 2009-02-13 make the coffee +wakeup
TODO: 3 marked as done.

>>> todo.sh report
x 2009-02-13 make the coffee +wakeup
TODO: $HOME/todo.txt archived.
2009-02-13T04:40:00 3 2
TODO: Report file updated.

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
2 stop and think
3 visit http://example.com
--
TODO: 3 of 3 tasks shown

>>> todo.sh -p listfile done.txt
2 x 2009-02-13 make the coffee +wakeup
1 x 2009-02-13 smell the coffee +wakeup
--
DONE: 2 of 2 tasks shown
EOF

test_todo_session 'report is unchanged when no changes' <<EOF
>>> cat report.txt
2009-02-13T04:40:00 5 0
2009-02-13T04:40:00 4 1
2009-02-13T04:40:00 3 2

>>> todo.sh report
TODO: $HOME/todo.txt archived.
2009-02-13T04:40:00 3 2
TODO: Report file is up-to-date.

>>> cat report.txt
2009-02-13T04:40:00 5 0
2009-02-13T04:40:00 4 1
2009-02-13T04:40:00 3 2
EOF

test_done
