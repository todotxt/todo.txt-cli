#!/usr/bin/env bash

test_description='highlighting date, item numbers and metadata

This test checks the highlighting (with colors) of dates, item numbers and metadata
'
. ./test-lib.sh

# Tasks with dates and metadata
cat > todo.txt <<EOF
(A) 2018-11-11 prioritized task with date
2018-11-11 task with date
x 2018-11-12 2018-11-11 done task with dates
x deadline 2018-12-01 buy xmas gifts
2018-11-12 2018-11-11 not yet done task with two dates
task with metadata due:2018-12-31
task without date except inline 2018-12-22 and without metadata
EOF

# config file specifying COLOR_PROJECT and COLOR_CONTEXT
#
TEST_TODO_LABEL_COLORS=todo-colors.cfg
{
    cat todo.cfg - <<'EOF'
export COLOR_DATE='\\033[0;31m'
export COLOR_META='\\033[0;32m'
export COLOR_NUMBER='\\033[0;34m'
EOF
} > "$TEST_TODO_LABEL_COLORS"

test_todo_session 'highlighting for date, item numbers and metadata' <<'EOF'
>>> todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[1;33m[0;34m1[0m[1;33m (A) [0;31m2018-11-11[0m[1;33m prioritized task with date[0m
[0;34m2[0m [0;31m2018-11-11[0m task with date
[0;34m5[0m [0;31m2018-11-12[0m 2018-11-11 not yet done task with two dates
[0;34m6[0m task with metadata [0;32mdue:2018-12-31[0m
[0;34m7[0m task without date except inline 2018-12-22 and without metadata
[0;37m[0;34m3[0m[0;37m x [0;31m2018-11-12[0m[0;37m [0;31m2018-11-11[0m[0;37m done task with dates[0m
[0;37m[0;34m4[0m[0;37m x deadline 2018-12-01 buy xmas gifts[0m
--
TODO: 7 of 7 tasks shown
EOF

test_todo_session 'suppressing highlighting for date, item numbers and metadata' <<'EOF'
>>> todo.sh -p -d "$TEST_TODO_LABEL_COLORS" ls
1 (A) 2018-11-11 prioritized task with date
2 2018-11-11 task with date
5 2018-11-12 2018-11-11 not yet done task with two dates
6 task with metadata due:2018-12-31
7 task without date except inline 2018-12-22 and without metadata
3 x 2018-11-12 2018-11-11 done task with dates
4 x deadline 2018-12-01 buy xmas gifts
--
TODO: 7 of 7 tasks shown
EOF

cat > todo.txt <<EOF
首都:都首
аБ:вГ 123456
a::b is not valid metadata because of the 2 colons
a:foo:bar is not valid
: :: ::: ::::
AB20 4834 CCED 2210 <>:<>
-:+
2025-05-30 {} (:)
|:-0
EOF
test_todo_session 'highlighting for non-ASCII metadata' <<'EOF'
>>> TODOTXT_SORT_COMMAND=cat todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;34m1[0m [0;32m首都:都首[0m
[0;34m2[0m [0;32mаБ:вГ[0m 123456
[0;34m3[0m a::b is not valid metadata because of the 2 colons
[0;34m4[0m a:foo:bar is not valid
[0;34m5[0m : :: ::: ::::
[0;34m6[0m AB20 4834 CCED 2210 [0;32m<>:<>[0m
[0;34m7[0m [0;32m-:+[0m
[0;34m8[0m [0;31m2025-05-30[0m {} [0;32m(:)[0m
[0;34m9[0m [0;32m|:-0[0m
--
TODO: 9 of 9 tasks shown
EOF

cat /dev/null > todo.txt
export TODOTXT_DATE_FORMAT='%D' TODOTXT_DATE_FORMAT_PATTERN='[0-9]{2}/[0-9]{2}/[0-9]{2}'
test_todo_session 'highlighting for date with custom date format (containing slashes)' <<'EOF'
>>> todo.sh -t add "new task due:2018-12-31"
1 02/13/09 new task due:2018-12-31
TODO: 1 added.

>>> todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;34m1[0m [0;31m02/13/09[0m new task [0;32mdue:2018-12-31[0m
--
TODO: 1 of 1 tasks shown

>>> todo.sh -a do 1
1 x 02/13/09 02/13/09 new task due:2018-12-31
TODO: 1 marked as done.

>>> todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;37m[0;34m1[0m[0;37m x [0;31m02/13/09[0m[0;37m [0;31m02/13/09[0m[0;37m new task [0;32mdue:2018-12-31[0m[0;37m[0m
--
TODO: 1 of 1 tasks shown
EOF
unset TODOTXT_DATE_FORMAT TODOTXT_DATE_FORMAT_PATTERN

test_done
