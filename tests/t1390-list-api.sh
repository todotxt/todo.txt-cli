#!/usr/bin/env bash
#

test_description='_list() API functionality

This test covers using the _list() API to list tasks.
'
. ./actions-test-lib.sh
. ./test-lib.sh

cat > todo.txt <<EOF
(A) @con01 +prj01 -- Some project 01 task, pri A
(A) @con01 +prj02 -- Some project 02 task, pri A
(A) @con02 +prj03 -- Some project 03 task, pri A
(A) @con02 +prj04 -- Some project 04 task, pri A
(B) @con01 +prj01 -- Some project 01 task, pri B
(B) @con01 +prj02 -- Some project 02 task, pri B
(B) @con02 +prj03 -- Some project 03 task, pri B
(B) @con02 +prj04 -- Some project 04 task, pri B
(C) @con01 +prj01 -- Some project 01 task, pri C
(C) @con01 +prj02 -- Some project 02 task, pri C
(C) @con02 +prj03 -- Some project 03 task, pri C
(C) @con02 +prj04 -- Some project 04 task, pri C
(D) @con01 +prj01 -- Some project 01 task, pri D
(D) @con01 +prj02 -- Some project 02 task, pri D
(D) @con02 +prj03 -- Some project 03 task, pri D
(D) @con02 +prj04 -- Some project 04 task, pri D
@con01 +prj01 -- Some project 01 task, no priority
@con01 +prj02 -- Some project(S) 02 task, no priority
@con02 +prj03 -- Some project 03 task, no priorty
@con02 +prj04 -- Some project 04 task, no priority
EOF

make_action testdriver-list '' '_list "$TODO_FILE"'
test_todo_session '_list() all tasks' <<EOF
>>> todo.sh testdriver-list
custom action testdriver-list
[1;33m01 (A) @con01 +prj01 -- Some project 01 task, pri A[0m
[1;33m02 (A) @con01 +prj02 -- Some project 02 task, pri A[0m
[1;33m03 (A) @con02 +prj03 -- Some project 03 task, pri A[0m
[1;33m04 (A) @con02 +prj04 -- Some project 04 task, pri A[0m
[0;32m05 (B) @con01 +prj01 -- Some project 01 task, pri B[0m
[0;32m06 (B) @con01 +prj02 -- Some project 02 task, pri B[0m
[0;32m07 (B) @con02 +prj03 -- Some project 03 task, pri B[0m
[0;32m08 (B) @con02 +prj04 -- Some project 04 task, pri B[0m
[1;34m09 (C) @con01 +prj01 -- Some project 01 task, pri C[0m
[1;34m10 (C) @con01 +prj02 -- Some project 02 task, pri C[0m
[1;34m11 (C) @con02 +prj03 -- Some project 03 task, pri C[0m
[1;34m12 (C) @con02 +prj04 -- Some project 04 task, pri C[0m
[1;37m13 (D) @con01 +prj01 -- Some project 01 task, pri D[0m
[1;37m14 (D) @con01 +prj02 -- Some project 02 task, pri D[0m
[1;37m15 (D) @con02 +prj03 -- Some project 03 task, pri D[0m
[1;37m16 (D) @con02 +prj04 -- Some project 04 task, pri D[0m
17 @con01 +prj01 -- Some project 01 task, no priority
18 @con01 +prj02 -- Some project(S) 02 task, no priority
19 @con02 +prj03 -- Some project 03 task, no priorty
20 @con02 +prj04 -- Some project 04 task, no priority
--
TODO: 20 of 20 tasks shown
EOF

make_action testdriver-list-nonverbose '' 'TODOTXT_VERBOSE=0 _list "$TODO_FILE"'
test_todo_session '_list() obeys TODOTXT_VERBOSE' <<EOF
>>> todo.sh testdriver-list-nonverbose
custom action testdriver-list-nonverbose
[1;33m01 (A) @con01 +prj01 -- Some project 01 task, pri A[0m
[1;33m02 (A) @con01 +prj02 -- Some project 02 task, pri A[0m
[1;33m03 (A) @con02 +prj03 -- Some project 03 task, pri A[0m
[1;33m04 (A) @con02 +prj04 -- Some project 04 task, pri A[0m
[0;32m05 (B) @con01 +prj01 -- Some project 01 task, pri B[0m
[0;32m06 (B) @con01 +prj02 -- Some project 02 task, pri B[0m
[0;32m07 (B) @con02 +prj03 -- Some project 03 task, pri B[0m
[0;32m08 (B) @con02 +prj04 -- Some project 04 task, pri B[0m
[1;34m09 (C) @con01 +prj01 -- Some project 01 task, pri C[0m
[1;34m10 (C) @con01 +prj02 -- Some project 02 task, pri C[0m
[1;34m11 (C) @con02 +prj03 -- Some project 03 task, pri C[0m
[1;34m12 (C) @con02 +prj04 -- Some project 04 task, pri C[0m
[1;37m13 (D) @con01 +prj01 -- Some project 01 task, pri D[0m
[1;37m14 (D) @con01 +prj02 -- Some project 02 task, pri D[0m
[1;37m15 (D) @con02 +prj03 -- Some project 03 task, pri D[0m
[1;37m16 (D) @con02 +prj04 -- Some project 04 task, pri D[0m
17 @con01 +prj01 -- Some project 01 task, no priority
18 @con01 +prj02 -- Some project(S) 02 task, no priority
19 @con02 +prj03 -- Some project 03 task, no priorty
20 @con02 +prj04 -- Some project 04 task, no priority
EOF

make_action testdriver-list-plain '' 'TODOTXT_PLAIN=1 _list "$TODO_FILE"'
false && test_todo_session '_list() obeys TODOTXT_PLAIN' <<EOF
>>> todo.sh testdriver-list-plain
custom action testdriver-list-plain
01 (A) @con01 +prj01 -- Some project 01 task, pri A
02 (A) @con01 +prj02 -- Some project 02 task, pri A
03 (A) @con02 +prj03 -- Some project 03 task, pri A
04 (A) @con02 +prj04 -- Some project 04 task, pri A
05 (B) @con01 +prj01 -- Some project 01 task, pri B
06 (B) @con01 +prj02 -- Some project 02 task, pri B
07 (B) @con02 +prj03 -- Some project 03 task, pri B
08 (B) @con02 +prj04 -- Some project 04 task, pri B
09 (C) @con01 +prj01 -- Some project 01 task, pri C
10 (C) @con01 +prj02 -- Some project 02 task, pri C
11 (C) @con02 +prj03 -- Some project 03 task, pri C
12 (C) @con02 +prj04 -- Some project 04 task, pri C
13 (D) @con01 +prj01 -- Some project 01 task, pri D
14 (D) @con01 +prj02 -- Some project 02 task, pri D
15 (D) @con02 +prj03 -- Some project 03 task, pri D
16 (D) @con02 +prj04 -- Some project 04 task, pri D
17 @con01 +prj01 -- Some project 01 task, no priority
18 @con01 +prj02 -- Some project(S) 02 task, no priority
19 @con02 +prj03 -- Some project 03 task, no priorty
20 @con02 +prj04 -- Some project 04 task, no priority
--
TODO: 20 of 20 tasks shown
EOF

test_done
