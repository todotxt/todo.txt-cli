#!/bin/sh

test_description='list project functionality
'
. ./test-lib.sh

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

test_done
