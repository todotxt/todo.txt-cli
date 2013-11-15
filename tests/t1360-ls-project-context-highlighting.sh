#!/bin/bash
#

test_description='highlighting projects and contexts

This test checks the highlighting (with colors) of projects and contexts.
'
. ./test-lib.sh

# Prioritized tasks with projects and contexts
cat > todo.txt <<EOF
(A) prioritized @con01 context
(B) prioritized +prj02 project
(C) prioritized context at EOL @con03
(D) prioritized project at EOL +prj04
+prj05 non-prioritized project at BOL
@con06 non-prioritized context at BOL
multiple @con_ @texts and +pro_ +jects
non-contexts: seti@home @ @* @(foo)
non-projects: lost+found + +! +(bar)
EOF

# config file specifying COLOR_PROJECT and COLOR_CONTEXT
#
TEST_TODO_LABEL_COLORS=todo-colors.cfg
cat todo.cfg > "$TEST_TODO_LABEL_COLORS"

echo "export COLOR_CONTEXT='\\\\033[1m'" >>"$TEST_TODO_LABEL_COLORS"
echo "export COLOR_PROJECT='\\\\033[2m'" >>"$TEST_TODO_LABEL_COLORS"

test_todo_session 'highlighting for contexts and projects' <<'EOF'
>>> todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[1;33m1 (A) prioritized [1m@con01[0m[1;33m context[0m
[0;32m2 (B) prioritized [2m+prj02[0m[0;32m project[0m
[1;34m3 (C) prioritized context at EOL [1m@con03[0m[1;34m[0m
[1;37m4 (D) prioritized project at EOL [2m+prj04[0m[1;37m[0m
5 [2m+prj05[0m non-prioritized project at BOL
6 [1m@con06[0m non-prioritized context at BOL
7 multiple [1m@con_[0m [1m@texts[0m and [2m+pro_[0m [2m+jects[0m
8 non-contexts: seti@home @ @* @(foo)
9 non-projects: lost+found + +! +(bar)
--
TODO: 9 of 9 tasks shown
EOF

test_todo_session 'suppressing highlighting for contexts and projects' <<'EOF'
>>> todo.sh -p -d "$TEST_TODO_LABEL_COLORS" ls
1 (A) prioritized @con01 context
2 (B) prioritized +prj02 project
3 (C) prioritized context at EOL @con03
4 (D) prioritized project at EOL +prj04
5 +prj05 non-prioritized project at BOL
6 @con06 non-prioritized context at BOL
7 multiple @con_ @texts and +pro_ +jects
8 non-contexts: seti@home @ @* @(foo)
9 non-projects: lost+found + +! +(bar)
--
TODO: 9 of 9 tasks shown
EOF

test_todo_session 'suppressing display of contexts' <<'EOF'
>>> todo.sh -@ -d "$TEST_TODO_LABEL_COLORS" ls
[1;33m1 (A) prioritized context[0m
[0;32m2 (B) prioritized [2m+prj02[0m[0;32m project[0m
[1;34m3 (C) prioritized context at EOL[0m
[1;37m4 (D) prioritized project at EOL [2m+prj04[0m[1;37m[0m
5 [2m+prj05[0m non-prioritized project at BOL
6 non-prioritized context at BOL
7 multiple and [2m+pro_[0m [2m+jects[0m
8 non-contexts: seti@home @
9 non-projects: lost+found + +! +(bar)
--
TODO: 9 of 9 tasks shown
EOF

test_todo_session 'suppressing display of projects' <<'EOF'
>>> todo.sh -+ -d "$TEST_TODO_LABEL_COLORS" ls
[1;33m1 (A) prioritized [1m@con01[0m[1;33m context[0m
[0;32m2 (B) prioritized project[0m
[1;34m3 (C) prioritized context at EOL [1m@con03[0m[1;34m[0m
[1;37m4 (D) prioritized project at EOL[0m
5 non-prioritized project at BOL
6 [1m@con06[0m non-prioritized context at BOL
7 multiple [1m@con_[0m [1m@texts[0m and
8 non-contexts: seti@home @ @* @(foo)
9 non-projects: lost+found +
--
TODO: 9 of 9 tasks shown
EOF

test_done
