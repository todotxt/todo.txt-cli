#!/bin/bash

test_description='basic tests imported from previous framework
'
. ./test-lib.sh

cat > todo.txt <<EOF
(B) smell the uppercase Roses +flowers @outside
(A) notice the sunflowers
stop
smell the coffee +wakeup
EOF
test_todo_session 'basic tests' <<EOF
>>> todo.sh -p list
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
4 smell the coffee +wakeup
3 stop
--
TODO: 4 of 4 tasks shown

>>> todo.sh -p list +flowers
1 (B) smell the uppercase Roses +flowers @outside
--
TODO: 1 of 4 tasks shown

>>> todo.sh -p list flowers
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
--
TODO: 2 of 4 tasks shown

>>> todo.sh -p list flowers out
1 (B) smell the uppercase Roses +flowers @outside
--
TODO: 1 of 4 tasks shown

>>> todo.sh -a do 2
2 x 2009-02-13 notice the sunflowers
TODO: 2 marked as done.

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
4 smell the coffee +wakeup
3 stop
2 x 2009-02-13 notice the sunflowers
--
TODO: 4 of 4 tasks shown

>>> todo.sh add "make the coffee +wakeup"
5 make the coffee +wakeup
TODO: 5 added.

>>> todo.sh -p list coffee
5 make the coffee +wakeup
4 smell the coffee +wakeup
--
TODO: 2 of 5 tasks shown

>>> todo.sh add "visit http://example.com"
6 visit http://example.com
TODO: 6 added.

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
5 make the coffee +wakeup
4 smell the coffee +wakeup
3 stop
6 visit http://example.com
2 x 2009-02-13 notice the sunflowers
--
TODO: 6 of 6 tasks shown

>>> todo.sh archive
x 2009-02-13 notice the sunflowers
TODO: $HOME/todo.txt archived.

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
4 make the coffee +wakeup
3 smell the coffee +wakeup
2 stop
5 visit http://example.com
--
TODO: 5 of 5 tasks shown

>>> todo.sh report
TODO: $HOME/todo.txt archived.
2009-02-13T04:40:00 5 1
TODO: Report file updated.

>>> todo.sh append g a
usage: todo.sh append ITEM# "TEXT TO APPEND"
=== 1

>>> todo.sh append 2 and think
2 stop and think

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
4 make the coffee +wakeup
3 smell the coffee +wakeup
2 stop and think
5 visit http://example.com
--
TODO: 5 of 5 tasks shown

>>> todo.sh append 10 "hej!"
TODO: No task 10.
=== 1

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
4 make the coffee +wakeup
3 smell the coffee +wakeup
2 stop and think
5 visit http://example.com
--
TODO: 5 of 5 tasks shown

>>> todo.sh do 10
TODO: No task 10.
=== 1

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
4 make the coffee +wakeup
3 smell the coffee +wakeup
2 stop and think
5 visit http://example.com
--
TODO: 5 of 5 tasks shown

>>> todo.sh add "the coffee +wakeup"
6 the coffee +wakeup
TODO: 6 added.

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
4 make the coffee +wakeup
3 smell the coffee +wakeup
2 stop and think
6 the coffee +wakeup
5 visit http://example.com
--
TODO: 6 of 6 tasks shown

>>> todo.sh prepend 6 "make"
6 make the coffee +wakeup

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
4 make the coffee +wakeup
6 make the coffee +wakeup
3 smell the coffee +wakeup
2 stop and think
5 visit http://example.com
--
TODO: 6 of 6 tasks shown

>>> todo.sh remdup
Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
Try 'todo.sh -h' for more information.
=== 1
EOF

test_done
