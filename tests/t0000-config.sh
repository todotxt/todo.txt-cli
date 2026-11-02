#!/usr/bin/env bash

test_description='todo.sh configuration file location

This test just makes sure that todo.sh can find its
config files in the default locations and take arguments
to find it somewhere else.
'
. ./test-lib.sh


# Override default global config file
export TODOTXT_GLOBAL_CFG_FILE=global.cfg

# Remove the pre-created todo.cfg to test behavior in its absence
rm -f todo.cfg
echo "Fatal Error: Cannot read configuration file $HOME/.todo/config" > expect
test_expect_code_and_output 1 'no config file' '
    todo.sh > output 2>&1
'

# All the below tests will output the usage message.
cat > expect <<EOF
$TODOTXT_ONELINE_USAGE
Try 'todo.sh -h' for more information.
EOF

cat > test.cfg <<'EOF'
export TODO_DIR=.
export TODO_FILE="$TODO_DIR/todo.txt"
export DONE_FILE="$TODO_DIR/done.txt"
export REPORT_FILE="$TODO_DIR/report.txt"
export TMP_FILE="$TODO_DIR/todo.tmp"
touch used_config
EOF

rm -f used_config
test_expect_code_and_output 0 'config file (default location 1)' '
    mkdir .todo
    cp test.cfg .todo/config
    todo.sh > output;
    rm -rf .todo
    test -f used_config
'

rm -f used_config
test_expect_code_and_output 0 'config file (default location 2)' '
    cp test.cfg todo.cfg
    todo.sh > output;
    rm -rf .todo
    test -f used_config
'

rm -f used_config
test_expect_code_and_output 0 'config file (default location 3)' '
    cp test.cfg .todo.cfg
    todo.sh > output;
    rm -rf .todo
    test -f used_config
'

rm -f used_config
test_expect_code_and_output 0 'config file (global config file)' '
    cp test.cfg "$TODOTXT_GLOBAL_CFG_FILE"
    todo.sh > output;
    rm -f "$TODOTXT_GLOBAL_CFG_FILE"
    test -f used_config
'

rm -f used_config
test_expect_code_and_output 0 'config file (command line)' '
    todo.sh -d test.cfg > output;
    test -f used_config
'

rm -f used_config
test_expect_code_and_output 0 'config file (env variable)' '
    TODOTXT_CFG_FILE=test.cfg todo.sh > output;
    test -f used_config
'

cat > minimal.cfg <<EOF
export TODO_DIR=.
touch used_config
EOF

rm -f used_config
test_expect_code_and_output 0 'config file (minimal)' '
    mkdir .todo
    cp minimal.cfg .todo/config
    todo.sh > output;
    rm -rf .todo
    test -f used_config
'

test_done
