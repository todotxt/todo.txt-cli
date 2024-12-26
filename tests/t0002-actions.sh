#!/usr/bin/env bash

test_description='todo.sh actions.d

This test just makes sure that todo.sh can locate custom actions.
'
. ./test-lib.sh

# All the below tests will output the custom action message
cat > expect <<EOF
TODO: foo
EOF

cat > foo <<EOF
echo "TODO: foo"
EOF
chmod +x foo

cat > foo2 << 'EOF'
shift
IFS=- # Print arguments separated with dashes to recognize the individual arguments.
printf 'TODO: %s\n' "$*"
EOF
chmod +x foo2

test_expect_success 'custom action (default location 1)' '
    mkdir -p .todo.actions.d && cp foo .todo.actions.d/
    todo.sh foo > output;
    test_cmp expect output && rm -rf .todo.actions.d
'

test_expect_success 'custom action (default location 2)' '
    mkdir -p .todo/actions && cp foo .todo/actions/
    todo.sh foo > output;
    test_cmp expect output && rm -rf .todo/actions
'

test_expect_success 'custom action (env variable)' '
    mkdir -p myactions && cp foo myactions/
    TODO_ACTIONS_DIR=myactions todo.sh foo > output;
    test_cmp expect output && rm -rf myactions
'

test_expect_success 'custom action (default action)' '
    mkdir -p .todo.actions.d && cp foo2 .todo.actions.d/
    TODOTXT_DEFAULT_ACTION="foo2 foo" todo.sh > output;
    test_cmp expect output && rm -rf .todo.actions.d
'

test_todo_session 'default built-in action with multiple arguments' <<EOF
>>> TODOTXT_DEFAULT_ACTION='add +foo @bar baz' todo.sh
1 +foo @bar baz
TODO: 1 added.
EOF

test_todo_session 'default custom action with multiple arguments' <<EOF
>>> mkdir -p .todo.actions.d && cp foo2 .todo.actions.d/

>>> TODOTXT_DEFAULT_ACTION='foo2 foo bar baz' todo.sh
TODO: foo-bar-baz
EOF

: > todo.txt
export TODOTXT_DEFAULT_ACTION="add foo\\ bar \\\$HOSTNAME O\\'Really\\? \\\"quoted\\\""
test_todo_session 'default built-in action with arguments that have special characters' <<EOF
>>> todo.sh
1 foo bar \$HOSTNAME O'Really? "quoted"
TODO: 1 added.
EOF

: > todo.txt
export TODOTXT_DEFAULT_ACTION="foo2 foo\\ bar \\\$HOSTNAME O\\'Really\\? \\\"quoted\\\""
test_todo_session 'default custom action with arguments that have special characters' <<EOF
>>> mkdir -p .todo.actions.d && cp foo2 .todo.actions.d/

>>> todo.sh
TODO: foo bar-\$HOSTNAME-O'Really?-"quoted"
EOF

test_done
