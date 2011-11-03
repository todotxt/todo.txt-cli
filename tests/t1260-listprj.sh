#!/bin/sh

test_description='list project functionality
'
. ./test-lib.sh

cat > todo.txt <<EOF
(B) smell the uppercase Roses +roses @outside
(C) notice the sunflowers +sunflowers @garden
stop
EOF
test_todo_session 'basic listproj' <<EOF
>>> todo.sh listproj
+roses
+sunflowers
EOF

test_todo_session 'listproj with context' <<EOF
>>> todo.sh listproj @garden
+sunflowers
EOF

test_done
