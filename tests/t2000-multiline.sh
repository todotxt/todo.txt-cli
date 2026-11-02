#!/usr/bin/env bash

test_description='Multi-line functionality'

. ./test-lib.sh

setupTodo()
{
    cat > todo.txt <<EOF
smell the cheese
EOF
}

## Replace test
cat > expect <<EOF
1 smell the cheese
TODO: Replaced task with:
1 eat apples eat oranges drink milk
EOF
setupTodo

test_expect_code_and_output 0 'multiline squash item replace' '
todo.sh replace 1 "eat apples
eat oranges
drink milk"
'

## Add test
cat > expect <<EOF
2 eat apples eat oranges drink milk
TODO: 2 added.
EOF
setupTodo

test_expect_code_and_output 0 'multiline squash item add' '
todo.sh add "eat apples
eat oranges
drink milk"
'

## Append test
cat > expect <<EOF
1 smell the cheese eat apples eat oranges drink milk
EOF
setupTodo

test_expect_code_and_output 0 'multiline squash item append' '
# Run append
todo.sh append 1 "eat apples
eat oranges
drink milk"
'

## Prepend test
cat > expect <<EOF
1 eat apples eat oranges drink milk smell the cheese
EOF
setupTodo

test_expect_code_and_output 0 'multiline squash item prepend' '
todo.sh prepend 1 "eat apples
eat oranges
drink milk"
'

## Multiple line addition
cat > expect <<EOF
2 eat apples
TODO: 2 added.
3 eat oranges
TODO: 3 added.
4 drink milk
TODO: 4 added.
EOF
setupTodo

test_expect_code_and_output 0 'actual multiline add' '
# Run addm
todo.sh addm "eat apples
eat oranges
drink milk"
'

test_done
