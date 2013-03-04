#!/bin/bash
#

test_description='list highlighting

This test checks the highlighting (with colors) of prioritized tasks.
'
. ./test-lib.sh

TEST_TODO_=todo.cfg

#
# check the highlighting of prioritized tasks
#
cat > todo.txt <<EOF
(A) @con01 +prj01 -- Some project 01 task, pri A
(B) @con02 +prj02 -- Some project 02 task, pri B
(C) @con01 +prj01 -- Some project 01 task, pri C
(D) @con02 +prj02 -- Some project 02 task, pri D
(E) @con01 +prj01 -- Some project 01 task, pri E
(Z) @con02 +prj02 -- Some project 02 task, pri Z
@con01 +prj01 -- Some project 01 task, no priority
@con02 +prj02 -- Some project 02 task, no priority
EOF
test_todo_session 'default highlighting' <<EOF
>>> todo.sh ls
[1;33m1 (A) @con01 +prj01 -- Some project 01 task, pri A[0m
[0;32m2 (B) @con02 +prj02 -- Some project 02 task, pri B[0m
[1;34m3 (C) @con01 +prj01 -- Some project 01 task, pri C[0m
[1;37m4 (D) @con02 +prj02 -- Some project 02 task, pri D[0m
[1;37m5 (E) @con01 +prj01 -- Some project 01 task, pri E[0m
[1;37m6 (Z) @con02 +prj02 -- Some project 02 task, pri Z[0m
7 @con01 +prj01 -- Some project 01 task, no priority
8 @con02 +prj02 -- Some project 02 task, no priority
--
TODO: 8 of 8 tasks shown
EOF

#
# check changing the color definitions into something other than ANSI color
# escape sequences
#
TEST_TODO_CUSTOM=todo-custom.cfg
cat todo.cfg > "$TEST_TODO_CUSTOM"
cat >> "$TEST_TODO_CUSTOM" <<'EOF'
export YELLOW='${color yellow}'
export GREEN='${color green}'
export LIGHT_BLUE='${color LightBlue}'
export WHITE='${color white}'
export DEFAULT='${color}'
export PRI_A=$YELLOW
export PRI_B=$GREEN
export PRI_C=$LIGHT_BLUE
export PRI_X=$WHITE
EOF
test_todo_session 'customized highlighting' <<'EOF'
>>> todo.sh -d "$TEST_TODO_CUSTOM" ls
${color yellow}1 (A) @con01 +prj01 -- Some project 01 task, pri A${color}
${color green}2 (B) @con02 +prj02 -- Some project 02 task, pri B${color}
${color LightBlue}3 (C) @con01 +prj01 -- Some project 01 task, pri C${color}
${color white}4 (D) @con02 +prj02 -- Some project 02 task, pri D${color}
${color white}5 (E) @con01 +prj01 -- Some project 01 task, pri E${color}
${color white}6 (Z) @con02 +prj02 -- Some project 02 task, pri Z${color}
7 @con01 +prj01 -- Some project 01 task, no priority
8 @con02 +prj02 -- Some project 02 task, no priority
--
TODO: 8 of 8 tasks shown
EOF

#
# check defining highlightings for more priorities than the default A, B, C
#
TEST_TODO_ADDITIONAL=todo-additional.cfg
cat todo.cfg > "$TEST_TODO_ADDITIONAL"
cat >> "$TEST_TODO_ADDITIONAL" <<'EOF'
export PRI_E=$BROWN
export PRI_Z=$LIGHT_PURPLE
EOF
test_todo_session 'additional highlighting pri E+Z' <<'EOF'
>>> todo.sh -d "$TEST_TODO_ADDITIONAL" ls
[1;33m1 (A) @con01 +prj01 -- Some project 01 task, pri A[0m
[0;32m2 (B) @con02 +prj02 -- Some project 02 task, pri B[0m
[1;34m3 (C) @con01 +prj01 -- Some project 01 task, pri C[0m
[1;37m4 (D) @con02 +prj02 -- Some project 02 task, pri D[0m
[0;33m5 (E) @con01 +prj01 -- Some project 01 task, pri E[0m
[1;35m6 (Z) @con02 +prj02 -- Some project 02 task, pri Z[0m
7 @con01 +prj01 -- Some project 01 task, no priority
8 @con02 +prj02 -- Some project 02 task, no priority
--
TODO: 8 of 8 tasks shown
EOF

# check changing the fallback highlighting for undefined priorities
#
TEST_TODO_PRI_X=todo-pri-x.cfg
cat todo.cfg > "$TEST_TODO_PRI_X"
cat >> "$TEST_TODO_PRI_X" <<'EOF'
export PRI_X=$BROWN
EOF
test_todo_session 'different highlighting for pri X' <<'EOF'
>>> todo.sh -d "$TEST_TODO_PRI_X" ls
[1;33m1 (A) @con01 +prj01 -- Some project 01 task, pri A[0m
[0;32m2 (B) @con02 +prj02 -- Some project 02 task, pri B[0m
[1;34m3 (C) @con01 +prj01 -- Some project 01 task, pri C[0m
[0;33m4 (D) @con02 +prj02 -- Some project 02 task, pri D[0m
[0;33m5 (E) @con01 +prj01 -- Some project 01 task, pri E[0m
[0;33m6 (Z) @con02 +prj02 -- Some project 02 task, pri Z[0m
7 @con01 +prj01 -- Some project 01 task, no priority
8 @con02 +prj02 -- Some project 02 task, no priority
--
TODO: 8 of 8 tasks shown
EOF

# check highlighting of done (but not yet archived) tasks
#
cat > todo.txt <<EOF
(A) smell the uppercase Roses +flowers @outside
remove1
notice the sunflowers
remove2
stop
EOF
test_todo_session 'highlighting of done tasks' <<EOF
>>> todo.sh -a do 2
2 x 2009-02-13 remove1
TODO: 2 marked as done.

>>> todo.sh list
[1;33m1 (A) smell the uppercase Roses +flowers @outside[0m
3 notice the sunflowers
4 remove2
5 stop
[0;37m2 x 2009-02-13 remove1[0m
--
TODO: 5 of 5 tasks shown

>>> todo.sh -a do 4
4 x 2009-02-13 remove2
TODO: 4 marked as done.

>>> todo.sh list
[1;33m1 (A) smell the uppercase Roses +flowers @outside[0m
3 notice the sunflowers
5 stop
[0;37m2 x 2009-02-13 remove1[0m
[0;37m4 x 2009-02-13 remove2[0m
--
TODO: 5 of 5 tasks shown
EOF

# check highlighting with hidden contexts/projects
#
cat > todo.txt <<EOF
(A) +project at the beginning, with priority
(B) with priority, ending in a +project
(C) @context at the beginning, with priority
(Z) with priority, ending in a @context
EOF
test_todo_session 'highlighting with hidden contexts/projects' <<EOF
>>> todo.sh -+ -@ list
[1;33m1 (A) at the beginning, with priority[0m
[0;32m2 (B) with priority, ending in a[0m
[1;34m3 (C) at the beginning, with priority[0m
[1;37m4 (Z) with priority, ending in a[0m
--
TODO: 4 of 4 tasks shown
EOF

# check that priorities are only matched at the start of the task
#
cat > todo.txt <<EOF
(D) some prioritized task
not prioritized
should not be seen as PRIORITIZE(D) task
EOF
test_todo_session 'highlighting priority position' <<EOF
>>> todo.sh ls
[1;37m1 (D) some prioritized task[0m
2 not prioritized
3 should not be seen as PRIORITIZE(D) task
--
TODO: 3 of 3 tasks shown
EOF

test_done
