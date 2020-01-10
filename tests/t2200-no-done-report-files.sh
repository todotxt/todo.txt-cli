#!/bin/bash
#

test_description='todo.sh configuration with a sole todo.txt data file.

This test covers turning off done.txt and report.txt, and
checks that no such empty files are created.
'
. ./test-lib.sh

cat > test.cfg << EOF
export TODO_DIR=.
export TODO_FILE="\$TODO_DIR/todo.txt"
export DONE_FILE=/dev/null
export REPORT_FILE=/dev/null
export TMP_FILE="\$TODO_DIR/todo.tmp"
touch used_config
EOF

test_todo_session 'invoke todo.sh' <<EOF
>>> todo.sh -d test.cfg add notice the daisies
1 notice the daisies
TODO: 1 added.
EOF

test_expect_success 'the todo file has been created' '[ -e todo.txt ]'
test_expect_success 'no done file has been created' '[ ! -e done.txt ]'
test_expect_success 'no report file has been created' '[ ! -e report.txt ]'

test_todo_session 'perform archive' <<EOF
>>> todo.sh -A -d test.cfg do 1
1 x 2009-02-13 notice the daisies
TODO: 1 marked as done.
x 2009-02-13 notice the daisies
TODO: ./todo.txt archived.
EOF

test_expect_success 'no done file has been created by the archiving' '[ ! -e done.txt ]'

test_todo_session 'perform report' <<EOF
>>> todo.sh -d test.cfg report
TODO: ./todo.txt archived.
2009-02-13T04:40:00 0 0
TODO: Report file updated.
EOF

test_expect_success 'no report file has been created by the reporting' '[ ! -e report.txt ]'

test_done
