#!/usr/bin/env bash

test_description='todo.sh basic null functionality test.

This test just makes sure the basic commands work,
when there are no todos.
'
. ./test-lib.sh

#
# ls|list
#
cat > expect <<EOF
--
TODO: 0 of 0 tasks shown
EOF

test_expect_code_and_output 0 'null ls' '
    todo.sh ls > output
'
test_expect_code_and_output 0 'null list' '
    todo.sh list > output
'
test_expect_code_and_output 0 'null list filter' '
    todo.sh list filter > output
'

#
# lsp|listpri
#
# Re-use expect from ls.
test_expect_code_and_output 0 'null lsp' '
    todo.sh lsp > output
'
test_expect_code_and_output 0 'null listpri' '
    todo.sh listpri > output
'
test_expect_code_and_output 0 'null listpri a' '
    todo.sh listpri a > output
'

#
# lsa|listall
#
cat > expect <<EOF
--
TODO: 0 of 0 tasks shown
DONE: 0 of 0 tasks shown
total 0 of 0 tasks shown
EOF

test_expect_code_and_output 0 'null lsa' '
    todo.sh lsa > output
'
test_expect_code_and_output 0 'null list' '
    todo.sh listall > output
'
test_expect_code_and_output 0 'null list filter' '
    todo.sh listall filter > output
'

#
# lsc|listcon
#
: > expect

test_expect_code_and_output 0 'null lsc' '
    todo.sh lsc > output
'
test_expect_code_and_output 0 'null listcon' '
    todo.sh listcon > output
'

#
# lsprj|listproj
#
: > expect

test_expect_code_and_output 0 'null lsprj' '
    todo.sh lsprj > output
'
test_expect_code_and_output 0 'null listproj' '
    todo.sh listproj > output
'

#
# lf|listfile
#
cat > expect <<EOF
Files in the todo.txt directory:
done.txt
report.txt
todo.txt
EOF
test_expect_code_and_output 0 'null lf' '
    todo.sh lf > output
'
test_expect_code_and_output 0 'null listfile' '
    todo.sh listfile > output
'
cat > expect <<EOF
TODO: File foo.txt does not exist.
EOF
test_expect_code_and_output 1 'null listfile foo.txt' '
    todo.sh listfile foo.txt > output
'

test_done
