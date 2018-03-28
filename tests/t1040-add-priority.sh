#!/bin/bash

test_description='test the priority on add feature'
. ./test-lib.sh

## Normal use case
echo "export TODOTXT_PRIORITY_ON_ADD=A" >> todo.cfg

test_todo_session 'config file priority' <<EOF
>>> todo.sh add take out the trash
1 (A) take out the trash
TODO: 1 added.

>>> todo.sh -p list
1 (A) take out the trash
--
TODO: 1 of 1 tasks shown
EOF

## Wrong value in config var
echo "export TODOTXT_PRIORITY_ON_ADD=1" >> todo.cfg

test_todo_session 'config file wrong priority' <<EOF
>>> todo.sh add fail to take out the trash
=== 1
TODOTXT_PRIORITY_ON_ADD should be a capital letter from A to Z (it is now "1").

>>> todo.sh -p list
=== 1
TODOTXT_PRIORITY_ON_ADD should be a capital letter from A to Z (it is now "1").
EOF

test_done
