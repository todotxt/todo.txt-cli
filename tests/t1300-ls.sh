#!/bin/sh
#

test_description='list functionality

This test checks various list functionality including
sorting, output filtering and line numbering.
'
. ./test-lib.sh

TEST_TODO_=todo.cfg

cat > todo.txt <<EOF
ccc xxx this line should be third.
aaa zzz this line should be first.
bbb yyy this line should be second.
EOF

#
# check the sort filter
#
TEST_TODO1_=todo1.cfg
sed -e "s/^.*export TODOTXT_SORT_COMMAND=.*$/export TODOTXT_SORT_COMMAND='env LC_COLLATE=C sort -r -f -k2'/" "${TEST_TODO_}" > "${TEST_TODO1_}"

test_todo_session 'checking TODOTXT_SORT_COMMAND' <<EOF
>>> todo.sh ls
2 aaa zzz this line should be first.
3 bbb yyy this line should be second.
1 ccc xxx this line should be third.
--
TODO: 3 of 3 tasks shown

>>> todo.sh -d "$TEST_TODO1_" ls
1 ccc xxx this line should be third.
3 bbb yyy this line should be second.
2 aaa zzz this line should be first.
--
TODO: 3 of 3 tasks shown
EOF

#
# check the final filter
#
TEST_TODO2_=todo2.cfg
sed -e "s%^.*export TODOTXT_FINAL_FILTER=.*$%export TODOTXT_FINAL_FILTER=\"sed 's/^\\\(..\\\{20\\\}\\\).....*$/\\\1.../'\"%" "${TEST_TODO_}" > "${TEST_TODO2_}"

test_todo_session 'checking TODOTXT_FINAL_FILTER' <<EOF
>>> todo.sh -d "$TEST_TODO2_" ls
2 aaa zzz this line s...
3 bbb yyy this line s...
1 ccc xxx this line s...
--
TODO: 3 of 3 tasks shown
EOF

#
# check the x command line option
#
TEST_TODO3_=todo3.cfg
sed -e "s%^.*export TODOTXT_FINAL_FILTER=.*$%export TODOTXT_FINAL_FILTER=\"grep -v xxx\"%" "${TEST_TODO_}" > "${TEST_TODO3_}"

cat > todo.txt <<EOF
foo
bar xxx
baz
EOF

test_todo_session 'final filter suppression' <<EOF
>>> todo.sh -d "$TEST_TODO3_" ls
3 baz
1 foo
--
TODO: 2 of 3 tasks shown

>>> todo.sh -d "$TEST_TODO3_" -x ls
2 bar xxx
3 baz
1 foo
--
TODO: 3 of 3 tasks shown
EOF

#
# check the p command line option
#
cat > todo.txt <<EOF
(A) @con01 +prj01 -- Some project 01 task, pri A
(A) @con01 +prj02 -- Some project 02 task, pri A
(A) @con02 +prj03 -- Some project 03 task, pri A
(A) @con02 +prj04 -- Some project 04 task, pri A
(B) @con01 +prj01 -- Some project 01 task, pri B
(B) @con01 +prj02 -- Some project 02 task, pri B
(B) @con02 +prj03 -- Some project 03 task, pri B
(B) @con02 +prj04 -- Some project 04 task, pri B
(C) @con01 +prj01 -- Some project 01 task, pri C
(C) @con01 +prj02 -- Some project 02 task, pri C
(C) @con02 +prj03 -- Some project 03 task, pri C
(C) @con02 +prj04 -- Some project 04 task, pri C
(D) @con01 +prj01 -- Some project 01 task, pri D
(D) @con01 +prj02 -- Some project 02 task, pri D
(D) @con02 +prj03 -- Some project 03 task, pri D
(D) @con02 +prj04 -- Some project 04 task, pri D
@con01 +prj01 -- Some project 01 task, no priority
@con01 +prj02 -- Some project 02 task, no priority
@con02 +prj03 -- Some project 03 task, no priorty
@con02 +prj04 -- Some project 04 task, no priority
EOF
test_todo_session 'plain mode option' <<EOF
>>> todo.sh ls
[1;33m01 (A) @con01 +prj01 -- Some project 01 task, pri A[0m
[1;33m02 (A) @con01 +prj02 -- Some project 02 task, pri A[0m
[1;33m03 (A) @con02 +prj03 -- Some project 03 task, pri A[0m
[1;33m04 (A) @con02 +prj04 -- Some project 04 task, pri A[0m
[0;32m05 (B) @con01 +prj01 -- Some project 01 task, pri B[0m
[0;32m06 (B) @con01 +prj02 -- Some project 02 task, pri B[0m
[0;32m07 (B) @con02 +prj03 -- Some project 03 task, pri B[0m
[0;32m08 (B) @con02 +prj04 -- Some project 04 task, pri B[0m
[1;34m09 (C) @con01 +prj01 -- Some project 01 task, pri C[0m
[1;34m10 (C) @con01 +prj02 -- Some project 02 task, pri C[0m
[1;34m11 (C) @con02 +prj03 -- Some project 03 task, pri C[0m
[1;34m12 (C) @con02 +prj04 -- Some project 04 task, pri C[0m
[1;37m13 (D) @con01 +prj01 -- Some project 01 task, pri D[0m
[1;37m14 (D) @con01 +prj02 -- Some project 02 task, pri D[0m
[1;37m15 (D) @con02 +prj03 -- Some project 03 task, pri D[0m
[1;37m16 (D) @con02 +prj04 -- Some project 04 task, pri D[0m
17 @con01 +prj01 -- Some project 01 task, no priority
18 @con01 +prj02 -- Some project 02 task, no priority
19 @con02 +prj03 -- Some project 03 task, no priorty
20 @con02 +prj04 -- Some project 04 task, no priority
--
TODO: 20 of 20 tasks shown

>>> todo.sh -p ls
01 (A) @con01 +prj01 -- Some project 01 task, pri A
02 (A) @con01 +prj02 -- Some project 02 task, pri A
03 (A) @con02 +prj03 -- Some project 03 task, pri A
04 (A) @con02 +prj04 -- Some project 04 task, pri A
05 (B) @con01 +prj01 -- Some project 01 task, pri B
06 (B) @con01 +prj02 -- Some project 02 task, pri B
07 (B) @con02 +prj03 -- Some project 03 task, pri B
08 (B) @con02 +prj04 -- Some project 04 task, pri B
09 (C) @con01 +prj01 -- Some project 01 task, pri C
10 (C) @con01 +prj02 -- Some project 02 task, pri C
11 (C) @con02 +prj03 -- Some project 03 task, pri C
12 (C) @con02 +prj04 -- Some project 04 task, pri C
13 (D) @con01 +prj01 -- Some project 01 task, pri D
14 (D) @con01 +prj02 -- Some project 02 task, pri D
15 (D) @con02 +prj03 -- Some project 03 task, pri D
16 (D) @con02 +prj04 -- Some project 04 task, pri D
17 @con01 +prj01 -- Some project 01 task, no priority
18 @con01 +prj02 -- Some project 02 task, no priority
19 @con02 +prj03 -- Some project 03 task, no priorty
20 @con02 +prj04 -- Some project 04 task, no priority
--
TODO: 20 of 20 tasks shown
EOF

#
# check the P,@,+ command line options
#
cat > todo.txt <<EOF
(A) @con01 +prj01 -- Some project 01 task, pri A
(A) @con01 +prj02 -- Some project 02 task, pri A
(A) @con02 +prj03 -- Some project 03 task, pri A
(A) @con02 +prj04 -- Some project 04 task, pri A
(B) @con01 +prj01 -- Some project 01 task, pri B
(B) @con01 +prj02 -- Some project 02 task, pri B
(B) @con02 +prj03 -- Some project 03 task, pri B
(B) @con02 +prj04 -- Some project 04 task, pri B
(C) @con01 +prj01 -- Some project 01 task, pri C
(C) @con01 +prj02 -- Some project 02 task, pri C
(C) @con02 +prj03 -- Some project 03 task, pri C
(C) @con02 +prj04 -- Some project 04 task, pri C
(D) @con01 +prj01 -- Some project 01 task, pri D
(D) @con01 +prj02 -- Some project 02 task, pri D
(D) @con02 +prj03 -- Some project 03 task, pri D
(D) @con02 +prj04 -- Some project 04 task, pri D
@con01 +prj01 -- Some project 01 task, no priority
@con01 +prj02 -- Some project 02 task, no priority
@con02 +prj03 -- Some project 03 task, no priorty
@con02 +prj04 -- Some project 04 task, no priority
EOF
test_todo_session 'context, project, and priority suppression' <<EOF
>>> todo.sh ls
[1;33m01 (A) @con01 +prj01 -- Some project 01 task, pri A[0m
[1;33m02 (A) @con01 +prj02 -- Some project 02 task, pri A[0m
[1;33m03 (A) @con02 +prj03 -- Some project 03 task, pri A[0m
[1;33m04 (A) @con02 +prj04 -- Some project 04 task, pri A[0m
[0;32m05 (B) @con01 +prj01 -- Some project 01 task, pri B[0m
[0;32m06 (B) @con01 +prj02 -- Some project 02 task, pri B[0m
[0;32m07 (B) @con02 +prj03 -- Some project 03 task, pri B[0m
[0;32m08 (B) @con02 +prj04 -- Some project 04 task, pri B[0m
[1;34m09 (C) @con01 +prj01 -- Some project 01 task, pri C[0m
[1;34m10 (C) @con01 +prj02 -- Some project 02 task, pri C[0m
[1;34m11 (C) @con02 +prj03 -- Some project 03 task, pri C[0m
[1;34m12 (C) @con02 +prj04 -- Some project 04 task, pri C[0m
[1;37m13 (D) @con01 +prj01 -- Some project 01 task, pri D[0m
[1;37m14 (D) @con01 +prj02 -- Some project 02 task, pri D[0m
[1;37m15 (D) @con02 +prj03 -- Some project 03 task, pri D[0m
[1;37m16 (D) @con02 +prj04 -- Some project 04 task, pri D[0m
17 @con01 +prj01 -- Some project 01 task, no priority
18 @con01 +prj02 -- Some project 02 task, no priority
19 @con02 +prj03 -- Some project 03 task, no priorty
20 @con02 +prj04 -- Some project 04 task, no priority
--
TODO: 20 of 20 tasks shown

>>> todo.sh ls @con01
[1;33m01 (A) @con01 +prj01 -- Some project 01 task, pri A[0m
[1;33m02 (A) @con01 +prj02 -- Some project 02 task, pri A[0m
[0;32m05 (B) @con01 +prj01 -- Some project 01 task, pri B[0m
[0;32m06 (B) @con01 +prj02 -- Some project 02 task, pri B[0m
[1;34m09 (C) @con01 +prj01 -- Some project 01 task, pri C[0m
[1;34m10 (C) @con01 +prj02 -- Some project 02 task, pri C[0m
[1;37m13 (D) @con01 +prj01 -- Some project 01 task, pri D[0m
[1;37m14 (D) @con01 +prj02 -- Some project 02 task, pri D[0m
17 @con01 +prj01 -- Some project 01 task, no priority
18 @con01 +prj02 -- Some project 02 task, no priority
--
TODO: 10 of 20 tasks shown

>>> todo.sh -P ls @con01
[1;33m01 @con01 +prj01 -- Some project 01 task, pri A[0m
[1;33m02 @con01 +prj02 -- Some project 02 task, pri A[0m
[0;32m05 @con01 +prj01 -- Some project 01 task, pri B[0m
[0;32m06 @con01 +prj02 -- Some project 02 task, pri B[0m
[1;34m09 @con01 +prj01 -- Some project 01 task, pri C[0m
[1;34m10 @con01 +prj02 -- Some project 02 task, pri C[0m
[1;37m13 @con01 +prj01 -- Some project 01 task, pri D[0m
[1;37m14 @con01 +prj02 -- Some project 02 task, pri D[0m
17 @con01 +prj01 -- Some project 01 task, no priority
18 @con01 +prj02 -- Some project 02 task, no priority
--
TODO: 10 of 20 tasks shown

>>> todo.sh -+ ls @con01
[1;33m01 (A) @con01 -- Some project 01 task, pri A[0m
[1;33m02 (A) @con01 -- Some project 02 task, pri A[0m
[0;32m05 (B) @con01 -- Some project 01 task, pri B[0m
[0;32m06 (B) @con01 -- Some project 02 task, pri B[0m
[1;34m09 (C) @con01 -- Some project 01 task, pri C[0m
[1;34m10 (C) @con01 -- Some project 02 task, pri C[0m
[1;37m13 (D) @con01 -- Some project 01 task, pri D[0m
[1;37m14 (D) @con01 -- Some project 02 task, pri D[0m
17 @con01 -- Some project 01 task, no priority
18 @con01 -- Some project 02 task, no priority
--
TODO: 10 of 20 tasks shown

>>> todo.sh -@ ls @con01
[1;33m01 (A) +prj01 -- Some project 01 task, pri A[0m
[1;33m02 (A) +prj02 -- Some project 02 task, pri A[0m
[0;32m05 (B) +prj01 -- Some project 01 task, pri B[0m
[0;32m06 (B) +prj02 -- Some project 02 task, pri B[0m
[1;34m09 (C) +prj01 -- Some project 01 task, pri C[0m
[1;34m10 (C) +prj02 -- Some project 02 task, pri C[0m
[1;37m13 (D) +prj01 -- Some project 01 task, pri D[0m
[1;37m14 (D) +prj02 -- Some project 02 task, pri D[0m
17 +prj01 -- Some project 01 task, no priority
18 +prj02 -- Some project 02 task, no priority
--
TODO: 10 of 20 tasks shown

>>> todo.sh -P -@ ls @con01
[1;33m01 +prj01 -- Some project 01 task, pri A[0m
[1;33m02 +prj02 -- Some project 02 task, pri A[0m
[0;32m05 +prj01 -- Some project 01 task, pri B[0m
[0;32m06 +prj02 -- Some project 02 task, pri B[0m
[1;34m09 +prj01 -- Some project 01 task, pri C[0m
[1;34m10 +prj02 -- Some project 02 task, pri C[0m
[1;37m13 +prj01 -- Some project 01 task, pri D[0m
[1;37m14 +prj02 -- Some project 02 task, pri D[0m
17 +prj01 -- Some project 01 task, no priority
18 +prj02 -- Some project 02 task, no priority
--
TODO: 10 of 20 tasks shown

>>> todo.sh -P -@ -+ -P -@ -+ ls @con01
[1;33m01 (A) @con01 +prj01 -- Some project 01 task, pri A[0m
[1;33m02 (A) @con01 +prj02 -- Some project 02 task, pri A[0m
[0;32m05 (B) @con01 +prj01 -- Some project 01 task, pri B[0m
[0;32m06 (B) @con01 +prj02 -- Some project 02 task, pri B[0m
[1;34m09 (C) @con01 +prj01 -- Some project 01 task, pri C[0m
[1;34m10 (C) @con01 +prj02 -- Some project 02 task, pri C[0m
[1;37m13 (D) @con01 +prj01 -- Some project 01 task, pri D[0m
[1;37m14 (D) @con01 +prj02 -- Some project 02 task, pri D[0m
17 @con01 +prj01 -- Some project 01 task, no priority
18 @con01 +prj02 -- Some project 02 task, no priority
--
TODO: 10 of 20 tasks shown

>>> todo.sh -P -@ -+ -P -@ -+ -P -@ -+ ls @con01
[1;33m01 -- Some project 01 task, pri A[0m
[1;33m02 -- Some project 02 task, pri A[0m
[0;32m05 -- Some project 01 task, pri B[0m
[0;32m06 -- Some project 02 task, pri B[0m
[1;34m09 -- Some project 01 task, pri C[0m
[1;34m10 -- Some project 02 task, pri C[0m
[1;37m13 -- Some project 01 task, pri D[0m
[1;37m14 -- Some project 02 task, pri D[0m
17 -- Some project 01 task, no priority
18 -- Some project 02 task, no priority
--
TODO: 10 of 20 tasks shown
EOF

#
# check the line number padding
#
cat > todo.txt <<EOF
hex00 this is one line
hex01 this is another line
hex02 this is another line
hex03 this is another line
hex04 this is another line
hex05 this is another line
hex06 this is another line
hex07 this is another line
hex08 this is another line
hex09 this is another line
hex0A this is another line
hex0B this is another line
hex0C this is another line
hex0D this is another line
hex0E this is another line
hex0F this is another line
hex10 this is line is a multiple of 16
hex11 this is another line
hex12 this is another line
hex13 this is another line
hex14 this is another line
hex15 this is another line
hex16 this is another line
hex17 this is another line
hex18 this is another line
hex19 this is another line
hex1A this is another line
hex1B this is another line
hex1C this is another line
hex1D this is another line
hex1E this is another line
hex1F this is another line
hex20 this is line is a multiple of 16
hex21 this is another line
hex22 this is another line
hex23 this is another line
hex24 this is another line
hex25 this is another line
hex26 this is another line
hex27 this is another line
hex28 this is another line
hex29 this is another line
hex2A this is another line
hex2B this is another line
hex2C this is another line
hex2D this is another line
hex2E this is another line
hex2F this is another line
hex30 this is line is a multiple of 16
hex31 this is another line
hex32 this is another line
hex33 this is another line
hex34 this is another line
hex35 this is another line
hex36 this is another line
hex37 this is another line
hex38 this is another line
hex39 this is another line
hex3A this is another line
hex3B this is another line
hex3C this is another line
hex3D this is another line
hex3E this is another line
hex3F this is another line
hex40 this is line is a multiple of 16
hex41 this is another line
hex42 this is another line
hex43 this is another line
hex44 this is another line
hex45 this is another line
hex46 this is another line
hex47 this is another line
hex48 this is another line
hex49 this is another line
hex4A this is another line
hex4B this is another line
hex4C this is another line
hex4D this is another line
hex4E this is another line
hex4F this is another line
hex50 this is line is a multiple of 16
hex51 this is another line
hex52 this is another line
hex53 this is another line
hex54 this is another line
hex55 this is another line
hex56 this is another line
hex57 this is another line
hex58 this is another line
hex59 this is another line
hex5A this is another line
hex5B this is another line
hex5C this is another line
hex5D this is another line
hex5E this is another line
hex5F this is another line
hex60 this is line is a multiple of 16
hex61 this is another line
hex62 this is another line
hex63 this is another line
hex64 this is another line
hex65 this is another line
hex66 this is another line
hex67 this is another line
hex68 this is another line
hex69 this is another line
hex6A this is another line
hex6B this is another line
hex6C this is another line
hex6D this is another line
hex6E this is another line
hex6F this is another line
EOF
test_todo_session 'check line number padding, out to 3 digits' <<EOF
>>> todo.sh ls
001 hex00 this is one line
002 hex01 this is another line
003 hex02 this is another line
004 hex03 this is another line
005 hex04 this is another line
006 hex05 this is another line
007 hex06 this is another line
008 hex07 this is another line
009 hex08 this is another line
010 hex09 this is another line
011 hex0A this is another line
012 hex0B this is another line
013 hex0C this is another line
014 hex0D this is another line
015 hex0E this is another line
016 hex0F this is another line
017 hex10 this is line is a multiple of 16
018 hex11 this is another line
019 hex12 this is another line
020 hex13 this is another line
021 hex14 this is another line
022 hex15 this is another line
023 hex16 this is another line
024 hex17 this is another line
025 hex18 this is another line
026 hex19 this is another line
027 hex1A this is another line
028 hex1B this is another line
029 hex1C this is another line
030 hex1D this is another line
031 hex1E this is another line
032 hex1F this is another line
033 hex20 this is line is a multiple of 16
034 hex21 this is another line
035 hex22 this is another line
036 hex23 this is another line
037 hex24 this is another line
038 hex25 this is another line
039 hex26 this is another line
040 hex27 this is another line
041 hex28 this is another line
042 hex29 this is another line
043 hex2A this is another line
044 hex2B this is another line
045 hex2C this is another line
046 hex2D this is another line
047 hex2E this is another line
048 hex2F this is another line
049 hex30 this is line is a multiple of 16
050 hex31 this is another line
051 hex32 this is another line
052 hex33 this is another line
053 hex34 this is another line
054 hex35 this is another line
055 hex36 this is another line
056 hex37 this is another line
057 hex38 this is another line
058 hex39 this is another line
059 hex3A this is another line
060 hex3B this is another line
061 hex3C this is another line
062 hex3D this is another line
063 hex3E this is another line
064 hex3F this is another line
065 hex40 this is line is a multiple of 16
066 hex41 this is another line
067 hex42 this is another line
068 hex43 this is another line
069 hex44 this is another line
070 hex45 this is another line
071 hex46 this is another line
072 hex47 this is another line
073 hex48 this is another line
074 hex49 this is another line
075 hex4A this is another line
076 hex4B this is another line
077 hex4C this is another line
078 hex4D this is another line
079 hex4E this is another line
080 hex4F this is another line
081 hex50 this is line is a multiple of 16
082 hex51 this is another line
083 hex52 this is another line
084 hex53 this is another line
085 hex54 this is another line
086 hex55 this is another line
087 hex56 this is another line
088 hex57 this is another line
089 hex58 this is another line
090 hex59 this is another line
091 hex5A this is another line
092 hex5B this is another line
093 hex5C this is another line
094 hex5D this is another line
095 hex5E this is another line
096 hex5F this is another line
097 hex60 this is line is a multiple of 16
098 hex61 this is another line
099 hex62 this is another line
100 hex63 this is another line
101 hex64 this is another line
102 hex65 this is another line
103 hex66 this is another line
104 hex67 this is another line
105 hex68 this is another line
106 hex69 this is another line
107 hex6A this is another line
108 hex6B this is another line
109 hex6C this is another line
110 hex6D this is another line
111 hex6E this is another line
112 hex6F this is another line
--
TODO: 112 of 112 tasks shown
EOF

#
# check that blank lines are ignored.
#

# Less than 10
cat > todo.txt <<EOF
hex00 this is one line

hex02 this is another line
hex03 this is another line
hex04 this is another line
hex05 this is another line
hex06 this is another line
hex07 this is another line
EOF
test_todo_session 'check that blank lines are ignored for less than 10 items' <<EOF
>>> todo.sh ls
1 hex00 this is one line
3 hex02 this is another line
4 hex03 this is another line
5 hex04 this is another line
6 hex05 this is another line
7 hex06 this is another line
8 hex07 this is another line
--
TODO: 7 of 7 tasks shown
EOF

# More than 10
cat > todo.txt <<EOF
hex00 this is one line

hex02 this is another line
hex03 this is another line
hex04 this is another line
hex05 this is another line
hex06 this is another line
hex07 this is another line
hex08 this is another line
hex09 this is another line
EOF
test_todo_session 'check that blank lines are ignored for blank lines whose ID begins with `0` (one blank)' <<EOF
>>> todo.sh ls
01 hex00 this is one line
03 hex02 this is another line
04 hex03 this is another line
05 hex04 this is another line
06 hex05 this is another line
07 hex06 this is another line
08 hex07 this is another line
09 hex08 this is another line
10 hex09 this is another line
--
TODO: 9 of 9 tasks shown
EOF
cat > todo.txt <<EOF
hex00 this is one line

hex02 this is another line
hex03 this is another line
hex04 this is another line
hex05 this is another line

hex07 this is another line
hex08 this is another line
hex09 this is another line
EOF
test_todo_session 'check that blank lines are ignored for blank lines whose ID begins with `0` (many blanks)' <<EOF
>>> todo.sh ls
01 hex00 this is one line
03 hex02 this is another line
04 hex03 this is another line
05 hex04 this is another line
06 hex05 this is another line
08 hex07 this is another line
09 hex08 this is another line
10 hex09 this is another line
--
TODO: 8 of 8 tasks shown
EOF

test_done
