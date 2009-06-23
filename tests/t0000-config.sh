#!/bin/sh

test_description='todo.sh configuration file location

This test just makes sure that todo.sh can find its
config files in the default locations and take arguments
to find it somewhere else.
'
. ./test-lib.sh

# Remove the pre-created todo.cfg to test behavior in its absence
rm -f todo.cfg
echo "Fatal error: Cannot read configuration file $HOME/.todo/config" > expect
test_expect_success 'no config file' '
    todo.sh > output 2>&1 || test_cmp expect output
'

# All the below tests will output the usage message.
cat > expect << EOF
Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
Try 'todo.sh -h' for more information.
EOF

cat > test.cfg << EOF
export TODO_DIR=.
export TODO_FILE="\$TODO_DIR/todo.txt"
export DONE_FILE="\$TODO_DIR/done.txt"
export REPORT_FILE="\$TODO_DIR/report.txt"
export TMP_FILE="\$TODO_DIR/todo.tmp"
touch used_config
EOF

rm -f used_config
test_expect_success 'config file (default location 1)' '
    mkdir .todo
    cp test.cfg .todo/config
    todo.sh > output;
    test_cmp expect output && test -f used_config &&
        rm -rf .todo
'

rm -f used_config
test_expect_success 'config file (default location 2)' '
    cp test.cfg todo.cfg
    todo.sh > output;
    test_cmp expect output && test -f used_config &&
        rm -f todo.cfg
'

rm -f used_config
test_expect_success 'config file (default location 3)' '
    cp test.cfg .todo.cfg
    todo.sh > output;
    test_cmp expect output && test -f used_config &&
        rm -f .todo.cfg
'

rm -f used_config
test_expect_success 'config file (command line)' '
    todo.sh -d test.cfg > output;
    test_cmp expect output && test -f used_config
'

rm -f used_config
test_expect_success 'config file (env variable)' '
    TODOTXT_CFG_FILE=test.cfg todo.sh > output;
    test_cmp expect output && test -f used_config
'

test_done
