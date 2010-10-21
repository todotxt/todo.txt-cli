#!/bin/sh
#

test_description='list with escape sequences

This test checks listing of tasks that have embedded escape sequences in them.
'
. ./test-lib.sh

#
# check aborted list output on \c escape sequence
#
cat > todo.txt <<'EOF'
first todo
second todo run C:\WINDOWS\sysnative\cscript.exe
third todo
EOF

test_todo_session 'aborted list output on backslash-c' <<'EOF'
>>> todo.sh ls
1 first todo
2 second todo run C:\\\\WINDOWS\\\\sysnative\\\\cscript.exe
3 third todo
--
TODO: 3 of 3 tasks shown

>>> todo.sh ls 2
2 second todo run C:\\\\WINDOWS\\\\sysnative\\\\cscript.exe
--
TODO: 1 of 3 tasks shown
EOF

test_done
