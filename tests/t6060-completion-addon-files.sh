#!/bin/bash
#

test_description='Bash add-on action file completion functionality

This test checks todo_completion of files for add-on actions that have file argument(s) configured
'
. ./test-lib.sh

readonly FILES='done.txt report.txt todo.txt'
test_todo_completion 'nothing after unconfigured bar' 'todo.sh bar ' ''

_todo_file1_actions='foo|bar'
test_todo_completion 'all files after configured bar' 'todo.sh bar ' "$FILES"
test_todo_completion 'nothing after configured bar ITEM#' 'todo.sh bar 1 ' ''

_todo_file2_actions='baz'
test_todo_completion 'nothing after configured baz' 'todo.sh baz ' ''
test_todo_completion 'all files after configured baz ITEM#' 'todo.sh baz 1 ' "$FILES"
test_todo_completion 'nothing after configured baz ITEM# MORE' 'todo.sh baz 1 more ' ''

_todo_file3_actions='biz'
test_todo_completion 'nothing after configured biz' 'todo.sh biz ' ''
test_todo_completion 'nothing after configured biz ITEM#' 'todo.sh biz 1 ' ''
test_todo_completion 'all files after configured biz ITEM# MORE' 'todo.sh biz 1 more ' "$FILES"
test_todo_completion 'nothing after configured biz ITEM# EVEN MORE' 'todo.sh biz 1 even more ' ''

test_done
