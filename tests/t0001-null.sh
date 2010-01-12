#!/bin/sh

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

test_expect_success 'null ls' '
    todo.sh ls > output && test_cmp expect output
'
test_expect_success 'null list' '
    todo.sh list > output && test_cmp expect output
'
test_expect_success 'null list filter' '
    todo.sh list filter > output && test_cmp expect output
'

#
# lsp|listpri
#
# Re-use expect from ls.
test_expect_success 'null lsp' '
    todo.sh lsp > output && test_cmp expect output
'
test_expect_success 'null listpri' '
    todo.sh listpri > output && test_cmp expect output
'
test_expect_success 'null listpri a' '
    todo.sh listpri a > output && test_cmp expect output
'

#
# lsa|listall
#
cat > expect <<EOF
--
TODO: 0 of 0 tasks shown
EOF

test_expect_success 'null lsa' '
    todo.sh lsa > output && test_cmp expect output
'
test_expect_success 'null list' '
    todo.sh listall > output && test_cmp expect output
'
test_expect_success 'null list filter' '
    todo.sh listall filter > output && test_cmp expect output
'


#
# lsc|listcon
#
test_expect_success 'null lsc' '
    todo.sh lsc > output && ! test -s output
'
test_expect_success 'null listcon' '
    todo.sh listcon > output && ! test -s output
'

#
# lsprj|listproj
#
test_expect_success 'null lsprj' '
    todo.sh lsprj > output && ! test -s output
'
test_expect_success 'null listproj' '
    todo.sh listproj > output && ! test -s output
'

#
# lf|listfile
#
cat > expect <<EOF
TODO: File  does not exist.
EOF
# XXX really should give a better usage error message here.
test_expect_success 'null lf' '
    todo.sh lf > output || test_cmp expect output
'
test_expect_success 'null listfile' '
    todo.sh listfile > output || test_cmp expect output
'
cat > expect <<EOF
TODO: File foo.txt does not exist.
EOF
test_expect_success 'null listfile foo.txt' '
    todo.sh listfile foo.txt > output || test_cmp expect output
'

test_done
