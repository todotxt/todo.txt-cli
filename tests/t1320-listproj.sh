#!/bin/bash
#

test_description='listproj functionality

This test checks basic project listing functionality
'
. ./test-lib.sh

cat > todo.txt <<EOF
item 1
item 2
item 3
EOF
test_expect_success 'listproj no projects' '
    todo.sh listproj > output && ! test -s output
'

cat > todo.txt <<EOF
(A) +1 -- Some project 1 task, whitespace, one char
(A) +p2 -- Some project 2 task, whitespace, two char
+prj03 -- Some project 3 task, no whitespace
+prj04 -- Some project 4 task, no whitespace
+prj05+prj06 -- weird project
EOF
test_todo_session 'Single project per line' <<EOF
>>> todo.sh listproj
+1
+p2
+prj03
+prj04
+prj05+prj06
EOF

cat > todo.txt <<EOF
+prj01 -- Some project 1 task
+prj02 -- Some project 2 task
+prj02 +prj03 -- Multi-project task
EOF
test_todo_session 'Multi-project per line' <<EOF
>>> todo.sh listproj
+prj01
+prj02
+prj03
EOF

cat > todo.txt <<EOF
+prj01 -- Some project 1 task
+prj02 -- Some project 2 task
+prj02 ginatrapani+todo@gmail.com -- Some project 2 task
EOF
test_todo_session 'listproj embedded + test' <<EOF
>>> todo.sh listproj
+prj01
+prj02
EOF

cat > todo.txt <<EOF
(B) smell the uppercase Roses +roses @outside +shared
(C) notice the sunflowers +sunflowers @garden +shared +landscape
stop
EOF
test_todo_session 'basic listproj' <<EOF
>>> todo.sh listproj
+landscape
+roses
+shared
+sunflowers
EOF

test_todo_session 'listproj with context' <<EOF
>>> todo.sh listproj @garden
+landscape
+shared
+sunflowers
EOF

TEST_TODO_CUSTOM=todo-custom.cfg
cat todo.cfg > "$TEST_TODO_CUSTOM"
cat >> "$TEST_TODO_CUSTOM" <<'EOF'
export DEFAULT='</color>'
export PRI_B='<color type=green>'
export PRI_C='<color type=blue>'
export TODOTXT_FINAL_FILTER='grep -i roses'
EOF
test_todo_session 'listproj with context special cases' <<EOF
>>> todo.sh -+ -d "$TEST_TODO_CUSTOM" listproj @garden
+landscape
+shared
+sunflowers
EOF


cat > todo.txt <<EOF
+prj01 -- Some project 1 task
EOF
cat > done.txt <<EOF
x 2012-02-21 +done01 -- Special project 1 done task
x 2012-02-21 +done02 -- Some project 2 done task
EOF
test_todo_session 'listproj from done tasks' <<'EOF'
>>> TODOTXT_SOURCEVAR=\$DONE_FILE todo.sh listproj
+done01
+done02
EOF
test_todo_session 'listproj from done tasks with filtering' <<'EOF'
>>> TODOTXT_SOURCEVAR=\$DONE_FILE todo.sh listproj Special
+done01
EOF
test_todo_session 'listproj from combined open + done tasks' <<'EOF'
>>> TODOTXT_SOURCEVAR='("$TODO_FILE" "$DONE_FILE")' todo.sh listproj
+done01
+done02
+prj01
EOF

test_todo_session 'listproj with GREP_OPTIONS disruption' <<'EOF'
>>> GREP_OPTIONS=-n todo.sh listproj
+prj01
EOF

test_done
