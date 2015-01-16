#!/bin/bash
#
# Copyright (c) 2015 Carlo Lobrano
#

test_description='Time management add-on

Count the total time spent on TODOs'

. ./actions-test-lib.sh
. ./test-lib.sh

# Setup the basic todo.txt
todo.sh add understand how test framework works >> /dev/null

make_action "donow"
cat  ../.todo.actions.d/donow >> .todo.actions.d/donow

test_todo_session 'donow on non existent item' <<EOF
>>> todo.sh donow 10
custom action donow
Could not find activity number 10
EOF

test_done


