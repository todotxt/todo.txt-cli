#!/usr/bin/env bash

test_description='addpri command functionality

Tests the addpri command which adds tasks with specified priority.
'
. ./test-lib.sh

# Test basic addpri functionality
test_todo_session 'basic addpri functionality' <<EOF
>>> todo.sh addpri A "High priority task"
1 (A) High priority task
TODO: 1 added.

>>> todo.sh addpri B "Medium priority task"
2 (B) Medium priority task
TODO: 2 added.

>>> todo.sh addpri Z "Low priority task"
3 (Z) Low priority task
TODO: 3 added.

>>> todo.sh -p list
1 (A) High priority task
2 (B) Medium priority task
3 (Z) Low priority task
--
TODO: 3 of 3 tasks shown
EOF

# Test lowercase priority conversion
cat > todo.txt <<EOF
EOF
test_todo_session 'lowercase priority conversion' <<EOF
>>> todo.sh addpri c "lowercase priority test"
1 (C) lowercase priority test
TODO: 1 added.

>>> todo.sh addpri z "another lowercase test"
2 (Z) another lowercase test
TODO: 2 added.

>>> todo.sh -p list
1 (C) lowercase priority test
2 (Z) another lowercase test
--
TODO: 2 of 2 tasks shown
EOF

# Test addpri with projects and contexts
cat > todo.txt <<EOF
EOF
test_todo_session 'addpri with projects and contexts' <<EOF
>>> todo.sh addpri A "Important work task +project @work"
1 (A) Important work task +project @work
TODO: 1 added.

>>> todo.sh addpri B "Call client +client @phone"
2 (B) Call client +client @phone
TODO: 2 added.

>>> todo.sh -p list
1 (A) Important work task +project @work
2 (B) Call client +client @phone
--
TODO: 2 of 2 tasks shown
EOF

# Test error handling - no arguments
cat > todo.txt <<EOF
EOF
test_todo_session 'addpri error - no arguments' <<EOF
>>> todo.sh addpri
usage: todo.sh addpri PRIORITY "TODO ITEM"
=== 1
EOF

# Test error handling - missing task text
test_todo_session 'addpri error - missing task text' <<EOF
>>> todo.sh addpri A
usage: todo.sh addpri PRIORITY "TODO ITEM"
=== 1
EOF

# Test error handling - invalid priority (number)
test_todo_session 'addpri error - invalid priority number' <<EOF
>>> todo.sh addpri 1 "Invalid priority task"
TODO: Priority must be a letter from A to Z (got: 1)
=== 1
EOF

# Test error handling - invalid priority (multiple characters)
test_todo_session 'addpri error - invalid priority multiple chars' <<EOF
>>> todo.sh addpri AA "Invalid priority task"
TODO: Priority must be a letter from A to Z (got: AA)
=== 1
EOF

# Test error handling - invalid priority (special character)
test_todo_session 'addpri error - invalid priority special char' <<EOF
>>> todo.sh addpri @ "Invalid priority task"
TODO: Priority must be a letter from A to Z (got: @)
=== 1
EOF

# Test addpri integration with date_on_add
cat > todo.txt <<EOF
EOF
echo "export TODOTXT_DATE_ON_ADD=1" >> todo.cfg

test_todo_session 'addpri with date on add' <<EOF
>>> todo.sh addpri A "Task with date"
1 (A) 2009-02-13 Task with date
TODO: 1 added.

>>> todo.sh -p list
1 (A) 2009-02-13 Task with date
--
TODO: 1 of 1 tasks shown
EOF

# Reset config for next test
echo "export TODOTXT_DATE_ON_ADD=0" >> todo.cfg

# Test that addpri overrides TODOTXT_PRIORITY_ON_ADD
cat > todo.txt <<EOF
EOF
echo "export TODOTXT_PRIORITY_ON_ADD=C" >> todo.cfg

test_todo_session 'addpri overrides PRIORITY_ON_ADD' <<EOF
>>> todo.sh addpri A "Priority A task"
1 (A) Priority A task
TODO: 1 added.

>>> todo.sh add "Normal add task"
2 (C) Normal add task
TODO: 2 added.

>>> todo.sh -p list
1 (A) Priority A task
2 (C) Normal add task
--
TODO: 2 of 2 tasks shown
EOF

# Test addpri with various edge cases
cat > todo.txt <<EOF
EOF
test_todo_session 'addpri edge cases' <<EOF
>>> todo.sh addpri E "Task with special chars: !@#$%^&*()"
1 (E) Task with special chars: !@#$%^&*()
TODO: 1 added.

>>> todo.sh addpri F "Task with 'single quotes' and \"double quotes\""
2 (F) Task with 'single quotes' and "double quotes"
TODO: 2 added.

>>> todo.sh -p list
1 (E) Task with special chars: !@#$%^&*()
2 (F) Task with 'single quotes' and "double quotes"
--
TODO: 2 of 2 tasks shown
EOF

test_done