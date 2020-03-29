#!/bin/bash
#

test_description='highlighting date, item numbers and metadata

This test checks the highlighting (with colors) of dates, item numbers and metadata
'
. ./test-lib.sh

# Tasks with dates and metadata
cat > todo.txt <<EOF
2018-11-11 task with date
task with metadata due:2018-12-31
task without date and without metadata
EOF

# config file specifying COLOR_PROJECT and COLOR_CONTEXT
#
TEST_TODO_LABEL_COLORS=todo-colors.cfg
cat todo.cfg > "$TEST_TODO_LABEL_COLORS"

echo "export COLOR_DATE='\\\\033[0;31m'" >>"$TEST_TODO_LABEL_COLORS"
echo "export COLOR_META='\\\\033[0;32m'" >>"$TEST_TODO_LABEL_COLORS"
echo "export COLOR_NUMBER='\\\\033[0;34m'" >>"$TEST_TODO_LABEL_COLORS"

test_todo_session 'highlighting for date, item numbers and metadata' <<'EOF'
>>> todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;34m1[0m [0;31m2018-11-11[0m task with date
[0;34m2[0m task with metadata [0;32mdue:2018-12-31[0m
[0;34m3[0m task without date and without metadata
--
TODO: 3 of 3 tasks shown
EOF


test_todo_session 'suppressing highlighting for date, item numbers and metadata' <<'EOF'
>>> todo.sh -p -d "$TEST_TODO_LABEL_COLORS" ls
1 2018-11-11 task with date
2 task with metadata due:2018-12-31
3 task without date and without metadata
--
TODO: 3 of 3 tasks shown
EOF

test_done
