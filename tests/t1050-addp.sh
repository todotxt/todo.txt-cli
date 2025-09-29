#!/usr/bin/env bash

test_description='addp command functionality

Tests the addp command which adds tasks with specified priority.
'
. ./test-lib.sh

# Test basic addp functionality
test_todo_session 'basic addp functionality' <<EOF
>>> todo.sh addp A "High priority task"
1 (A) High priority task
TODO: 1 added.

>>> todo.sh addp B "Medium priority task"
2 (B) Medium priority task
TODO: 2 added.

>>> todo.sh addp Z "Low priority task"
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
>>> todo.sh addp c "lowercase priority test"
1 (C) lowercase priority test
TODO: 1 added.

>>> todo.sh addp z "another lowercase test"
2 (Z) another lowercase test
TODO: 2 added.

>>> todo.sh -p list
1 (C) lowercase priority test
2 (Z) another lowercase test
--
TODO: 2 of 2 tasks shown
EOF

# Test addp with projects and contexts
cat > todo.txt <<EOF
EOF
test_todo_session 'addp with projects and contexts' <<EOF
>>> todo.sh addp A "Important work task +project @work"
1 (A) Important work task +project @work
TODO: 1 added.

>>> todo.sh addp B "Call client +client @phone"
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
test_todo_session 'addp error - no arguments' <<EOF
>>> todo.sh addp
usage: todo.sh addp PRIORITY "TODO ITEM"
=== 1
EOF

# Test error handling - missing task text
test_todo_session 'addp error - missing task text' <<EOF
>>> todo.sh addp A
usage: todo.sh addp PRIORITY "TODO ITEM"
=== 1
EOF

# Test error handling - invalid priority (number)
test_todo_session 'addp error - invalid priority number' <<EOF
>>> todo.sh addp 1 "Invalid priority task"
TODO: Priority must be a letter from A to Z (got: 1)
=== 1
EOF

# Test error handling - invalid priority (multiple characters)
test_todo_session 'addp error - invalid priority multiple chars' <<EOF
>>> todo.sh addp AA "Invalid priority task"
TODO: Priority must be a letter from A to Z (got: AA)
=== 1
EOF

# Test error handling - invalid priority (special character)
test_todo_session 'addp error - invalid priority special char' <<EOF
>>> todo.sh addp @ "Invalid priority task"
TODO: Priority must be a letter from A to Z (got: @)
=== 1
EOF

# Test addp integration with date_on_add
cat > todo.txt <<EOF
EOF
echo "export TODOTXT_DATE_ON_ADD=1" >> todo.cfg

test_todo_session 'addp with date on add' <<EOF
>>> todo.sh addp A "Task with date"
1 (A) $(date '+%Y-%m-%d') Task with date
TODO: 1 added.

>>> todo.sh -p list
1 (A) $(date '+%Y-%m-%d') Task with date
--
TODO: 1 of 1 tasks shown
EOF

# Reset config for next test
echo "export TODOTXT_DATE_ON_ADD=0" >> todo.cfg

# Test that addp overrides TODOTXT_PRIORITY_ON_ADD
cat > todo.txt <<EOF
EOF
echo "export TODOTXT_PRIORITY_ON_ADD=C" >> todo.cfg

test_todo_session 'addp overrides PRIORITY_ON_ADD' <<EOF
>>> todo.sh addp A "Priority A task"
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

# Test addp with various edge cases
cat > todo.txt <<EOF
EOF
test_todo_session 'addp edge cases' <<EOF
>>> todo.sh addp E "Task with special chars: !@#$%^&*()"
1 (E) Task with special chars: !@#$%^&*()
TODO: 1 added.

>>> todo.sh addp F "Task with 'single quotes' and \"double quotes\""
2 (F) Task with 'single quotes' and "double quotes"
TODO: 2 added.

>>> todo.sh -p list
1 (E) Task with special chars: !@#$%^&*()
2 (F) Task with 'single quotes' and "double quotes"
--
TODO: 2 of 2 tasks shown
EOF

test_done