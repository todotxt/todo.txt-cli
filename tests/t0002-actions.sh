#!/bin/bash

test_description='todo.sh actions.d

This test just makes sure that todo.sh can locate custom actions.
'
. ./test-lib.sh

# All the below tests will output the custom action message
cat > expect << EOF
TODO: foo
EOF

cat > foo << EOF
echo "TODO: foo"
EOF
chmod +x foo

test_expect_success 'custom action (default location 1)' '
    mkdir .todo.actions.d
    cp foo .todo.actions.d/
    todo.sh foo > output;
    test_cmp expect output && rm -rf .todo.actions.d
'

test_expect_success 'custom action (default location 2)' '
    mkdir -p .todo/actions
    cp foo .todo/actions/
    todo.sh foo > output;
    test_cmp expect output && rm -rf .todo/actions
'

test_expect_success 'custom action (env variable)' '
    mkdir myactions
    cp foo myactions/
    TODO_ACTIONS_DIR=myactions todo.sh foo > output;
    test_cmp expect output && rm -rf myactions
'

test_done
