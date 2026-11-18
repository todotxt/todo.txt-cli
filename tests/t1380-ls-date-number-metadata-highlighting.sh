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
a::b is unusual but valid metadata because of the 2 colons
a:foo:bar is valid
a: b: c: def: all have no value, which is valid
: :: ::: ::::
AB20 4834 CCED 2210 <>:<>
-:+
2025-05-30 {} (:)
|:-0
EOF
test_todo_session 'highlighting of metadata cornercases' <<'EOF'
>>> TODOTXT_SORT_COMMAND=cat todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;34m1[0m [0;32ma::b[0m is unusual but valid metadata because of the 2 colons
[0;34m2[0m [0;32ma:foo:bar[0m is valid
[0;34m3[0m [0;32ma:[0m [0;32mb:[0m [0;32mc:[0m [0;32mdef:[0m all have no value, which is valid
[0;34m4[0m : :: ::: ::::
[0;34m5[0m AB20 4834 CCED 2210 [0;32m<>:<>[0m
[0;34m6[0m [0;32m-:+[0m
[0;34m7[0m [0;31m2025-05-30[0m {} [0;32m(:)[0m
[0;34m8[0m [0;32m|:-0[0m
--
TODO: 8 of 8 tasks shown
EOF
test_todo_session 'highlighting of customized metadata syntax' <<'EOF'
>>> TODOTXT_METADATA_VALID_PATTERN='[^:[:space:]]:[^[:space:]]{0,}' TODOTXT_SORT_COMMAND=cat todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;34m1[0m [0;32ma::b[0m is unusual but valid metadata because of the 2 colons
[0;34m2[0m [0;32ma:foo:bar[0m is valid
[0;34m3[0m [0;32ma:[0m [0;32mb:[0m [0;32mc:[0m def: all have no value, which is valid
[0;34m4[0m : :: ::: ::::
[0;34m5[0m AB20 4834 CCED 2210 <>:<>
[0;34m6[0m [0;32m-:+[0m
[0;34m7[0m [0;31m2025-05-30[0m {} [0;32m(:)[0m
[0;34m8[0m [0;32m|:-0[0m
--
TODO: 8 of 8 tasks shown

>>> TODOTXT_METADATA_VALID_PATTERN='[^:[:space:]]:[^:[:space:]]{0,}' TODOTXT_SORT_COMMAND=cat todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;34m1[0m a::b is unusual but valid metadata because of the 2 colons
[0;34m2[0m a:foo:bar is valid
[0;34m3[0m [0;32ma:[0m [0;32mb:[0m [0;32mc:[0m def: all have no value, which is valid
[0;34m4[0m : :: ::: ::::
[0;34m5[0m AB20 4834 CCED 2210 <>:<>
[0;34m6[0m [0;32m-:+[0m
[0;34m7[0m [0;31m2025-05-30[0m {} [0;32m(:)[0m
[0;34m8[0m [0;32m|:-0[0m
--
TODO: 8 of 8 tasks shown

>>> TODOTXT_METADATA_VALID_PATTERN='[a-z]:[^[:space:]]{0,}' TODOTXT_SORT_COMMAND=cat todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;34m1[0m [0;32ma::b[0m is unusual but valid metadata because of the 2 colons
[0;34m2[0m [0;32ma:foo:bar[0m is valid
[0;34m3[0m [0;32ma:[0m [0;32mb:[0m [0;32mc:[0m def: all have no value, which is valid
[0;34m4[0m : :: ::: ::::
[0;34m5[0m AB20 4834 CCED 2210 <>:<>
[0;34m6[0m -:+
[0;34m7[0m [0;31m2025-05-30[0m {} (:)
[0;34m8[0m |:-0
--
TODO: 8 of 8 tasks shown
EOF

cat > todo.txt <<EOF
Umlaut Ü:§282 paragraph
h:עברית
key 彁:text is non-ASCII
value t:彁 is non-ASCII
首都:都首
首X都:mixed-都首
аБ:вГ 123456
EOF
test_todo_session 'highlighting for non-ASCII metadata' <<'EOF'
>>> TODOTXT_SORT_COMMAND=cat todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;34m1[0m Umlaut [0;32mÜ:§282[0m paragraph
[0;34m2[0m [0;32mh:עברית[0m
[0;34m3[0m key [0;32m彁:text[0m is non-ASCII
[0;34m4[0m value [0;32mt:彁[0m is non-ASCII
[0;34m5[0m [0;32m首都:都首[0m
[0;34m6[0m [0;32m首X都:mixed-都首[0m
[0;34m7[0m [0;32mаБ:вГ[0m 123456
--
TODO: 7 of 7 tasks shown
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
