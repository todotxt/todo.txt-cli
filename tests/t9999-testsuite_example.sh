#!/bin/sh

test_description='basic tests imported from previous framework
'
. ./test-lib.sh

test_todo_session 'basic tests' <<EOF
>>> todo.sh add "notice the daisies"
TODO: 'notice the daisies' added on line 1.

>>> todo.sh list
1 notice the daisies
--
TODO: 1 of 1 tasks shown from $HOME/todo.txt

>>> todo.sh replace adf asdfa
usage: $HOME/bin/todo.sh replace ITEM# "UPDATED ITEM"
=== 1

>>> todo.sh replace 1 "smell the cows"
1: notice the daisies
replaced with
1: smell the cows

>>> todo.sh list
1 smell the cows
--
TODO: 1 of 1 tasks shown from $HOME/todo.txt

>>> todo.sh replace 1 smell the roses
1: smell the cows
replaced with
1: smell the roses

>>> todo.sh list
1 smell the roses
--
TODO: 1 of 1 tasks shown from $HOME/todo.txt

>>> todo.sh replace 1 smell the uppercase Roses
1: smell the roses
replaced with
1: smell the uppercase Roses

>>> todo.sh list
1 smell the uppercase Roses
--
TODO: 1 of 1 tasks shown from $HOME/todo.txt

>>> todo.sh list roses
1 smell the uppercase Roses
--
TODO: 1 of 1 tasks shown from $HOME/todo.txt

>>> todo.sh add notice the sunflowers
TODO: 'notice the sunflowers' added on line 2.

>>> todo.sh list
2 notice the sunflowers
1 smell the uppercase Roses
--
TODO: 2 of 2 tasks shown from $HOME/todo.txt

>>> todo.sh append 1 +flowers @outside
1: smell the uppercase Roses +flowers @outside

>>> todo.sh list
2 notice the sunflowers
1 smell the uppercase Roses +flowers @outside
--
TODO: 2 of 2 tasks shown from $HOME/todo.txt

>>> todo.sh add "stop"
TODO: 'stop' added on line 3.

>>> todo.sh list
2 notice the sunflowers
1 smell the uppercase Roses +flowers @outside
3 stop
--
TODO: 3 of 3 tasks shown from $HOME/todo.txt

>>> todo.sh pri B B
usage: $HOME/bin/todo.sh pri ITEM# PRIORITY
note: PRIORITY must be anywhere from A to Z.
=== 1

>>> todo.sh pri 1 B
1: (B) smell the uppercase Roses +flowers @outside
TODO: 1 prioritized (B).

>>> todo.sh list
[0;32m1 (B) smell the uppercase Roses +flowers @outside[0m
2 notice the sunflowers
3 stop
--
TODO: 3 of 3 tasks shown from $HOME/todo.txt

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
2 notice the sunflowers
3 stop
--
TODO: 3 of 3 tasks shown from $HOME/todo.txt

>>> todo.sh pri 2 C
2: (C) notice the sunflowers
TODO: 2 prioritized (C).

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
2 (C) notice the sunflowers
3 stop
--
TODO: 3 of 3 tasks shown from $HOME/todo.txt

>>> todo.sh pri 2 A
2: (A) notice the sunflowers
TODO: 2 prioritized (A).

>>> todo.sh -p list
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
3 stop
--
TODO: 3 of 3 tasks shown from $HOME/todo.txt

>>> todo.sh pri 2 a
2: (A) notice the sunflowers
TODO: 2 prioritized (A).

>>> todo.sh -p listpri
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
--
TODO: 2 of 3 tasks shown from $HOME/todo.txt

>>> todo.sh add "smell the coffee +wakeup"
TODO: 'smell the coffee +wakeup' added on line 4.

>>> todo.sh -p list
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
4 smell the coffee +wakeup
3 stop
--
TODO: 4 of 4 tasks shown from $HOME/todo.txt

>>> todo.sh -p list +flowers
1 (B) smell the uppercase Roses +flowers @outside
--
TODO: 1 of 4 tasks shown from $HOME/todo.txt

>>> todo.sh -p list flowers
2 (A) notice the sunflowers
1 (B) smell the uppercase Roses +flowers @outside
--
TODO: 2 of 4 tasks shown from $HOME/todo.txt

>>> todo.sh -p list flowers out
1 (B) smell the uppercase Roses +flowers @outside
--
TODO: 1 of 4 tasks shown from $HOME/todo.txt

>>> todo.sh -a do 2
2: x 2009-02-13 notice the sunflowers
TODO: 2 marked as done.

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
4 smell the coffee +wakeup
3 stop
2 x 2009-02-13 notice the sunflowers
--
TODO: 4 of 4 tasks shown from $HOME/todo.txt

>>> todo.sh add "make the coffee +wakeup"
TODO: 'make the coffee +wakeup' added on line 5.

>>> todo.sh -p list coffee
5 make the coffee +wakeup
4 smell the coffee +wakeup
--
TODO: 2 of 5 tasks shown from $HOME/todo.txt

>>> todo.sh add "visit http://example.com"
TODO: 'visit http://example.com' added on line 6.

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
5 make the coffee +wakeup
4 smell the coffee +wakeup
3 stop
6 visit http://example.com
2 x 2009-02-13 notice the sunflowers
--
TODO: 6 of 6 tasks shown from $HOME/todo.txt

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
TODO: 5 of 5 tasks shown from $HOME/todo.txt

>>> todo.sh report
TODO: Report file updated.
2009-02-13-04:40:00 5 1

>>> todo.sh report
TODO: Report file updated.
2009-02-13-04:40:00 5 1
2009-02-13-04:40:00 5 1

>>> todo.sh append g a
usage: $HOME/bin/todo.sh append ITEM# "TEXT TO APPEND"
=== 1

>>> todo.sh append 2 and think
2: stop and think

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
4 make the coffee +wakeup
3 smell the coffee +wakeup
2 stop and think
5 visit http://example.com
--
TODO: 5 of 5 tasks shown from $HOME/todo.txt

>>> todo.sh pri 2 C
2: (C) stop and think
TODO: 2 prioritized (C).

>>> todo.sh replace 10 "hej!"
10: No such todo.
=== 1

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
2 (C) stop and think
4 make the coffee +wakeup
3 smell the coffee +wakeup
5 visit http://example.com
--
TODO: 5 of 5 tasks shown from $HOME/todo.txt

>>> todo.sh append 10 "hej!"
10: No such todo.
=== 1

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
2 (C) stop and think
4 make the coffee +wakeup
3 smell the coffee +wakeup
5 visit http://example.com
--
TODO: 5 of 5 tasks shown from $HOME/todo.txt

>>> todo.sh do 10
10: No such todo.
=== 1

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
2 (C) stop and think
4 make the coffee +wakeup
3 smell the coffee +wakeup
5 visit http://example.com
--
TODO: 5 of 5 tasks shown from $HOME/todo.txt

>>> todo.sh add "the coffee +wakeup"
TODO: 'the coffee +wakeup' added on line 6.

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
2 (C) stop and think
4 make the coffee +wakeup
3 smell the coffee +wakeup
6 the coffee +wakeup
5 visit http://example.com
--
TODO: 6 of 6 tasks shown from $HOME/todo.txt

>>> todo.sh prepend 6 "make"
6: make the coffee +wakeup

>>> todo.sh -p list
1 (B) smell the uppercase Roses +flowers @outside
2 (C) stop and think
4 make the coffee +wakeup
6 make the coffee +wakeup
3 smell the coffee +wakeup
5 visit http://example.com
--
TODO: 6 of 6 tasks shown from $HOME/todo.txt

>>> todo.sh remdup
Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
Try 'todo.sh -h' for more information.
=== 1
EOF

test_done
