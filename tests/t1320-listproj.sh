#!/bin/sh
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

test_done
