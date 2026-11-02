#!/usr/bin/env bash

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
non-contexts: seti@home @
non-projects: lost+found +
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
8 non-contexts: seti@home @
9 non-projects: lost+found +
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
8 non-contexts: seti@home @
9 non-projects: lost+found +
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
9 non-projects: lost+found +
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
8 non-contexts: seti@home @
9 non-projects: lost+found +
--
TODO: 9 of 9 tasks shown
EOF

cat > todo.txt <<EOF
2024-01-01 абв где ёжз +ИКЛ
икл мно прс @ТУФ
2025-11-27 tell about bug in todo.sh +абвГдеЁжз
@иклМноПрс
να ξαπλώσω στο μπάνιο και να φωνάξω +εύρηκα
:) @---
2025-11-26 @+++
++++ @@@@
Visit Bolshoi theater +Москва
购买蔬菜 +首都
Catch white nights in June 2026 +Санкт-Петербург
EOF
test_todo_session 'highlighting for non-ASCII contexts and projects' <<'EOF'
>>> TODOTXT_SORT_COMMAND=cat todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
01 2024-01-01 абв где ёжз [2m+ИКЛ[0m
02 икл мно прс [1m@ТУФ[0m
03 2025-11-27 tell about bug in todo.sh [2m+абвГдеЁжз[0m
04 [1m@иклМноПрс[0m
05 να ξαπλώσω στο μπάνιο και να φωνάξω [2m+εύρηκα[0m
06 :) [1m@---[0m
07 2025-11-26 [1m@+++[0m
08 [2m++++[0m [1m@@@@[0m
09 Visit Bolshoi theater [2m+Москва[0m
10 购买蔬菜 [2m+首都[0m
11 Catch white nights in June 2026 [2m+Санкт-Петербург[0m
--
TODO: 11 of 11 tasks shown
EOF

# check highlighting with custom sigil patterns
cat > todo.txt <<EOF
(B) +math w:+calculus (@school or @home) integrate @x and (@y) and @z
say thanks and give a +1 to @GinaTrapani w:@OtherContributors
EOF
test_todo_session 'highlighting with default configuration' <<EOF
>>> todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;32m1 (B) [2m+math[0m[0;32m w:+calculus (@school or [1m@home)[0m[0;32m integrate [1m@x[0m[0;32m and (@y) and [1m@z[0m[0;32m[0m
2 say thanks and give a [2m+1[0m to [1m@GinaTrapani[0m w:@OtherContributors
--
TODO: 2 of 2 tasks shown
EOF
test_todo_session 'highlighting limiting projects and contexts to multi-character sequences' <<EOF
>>> TODOTXT_SIGIL_VALID_PATTERN='.{2,}' todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;32m1 (B) [2m+math[0m[0;32m w:+calculus (@school or [1m@home)[0m[0;32m integrate @x and (@y) and @z[0m
2 say thanks and give a +1 to [1m@GinaTrapani[0m w:@OtherContributors
--
TODO: 2 of 2 tasks shown
EOF
test_todo_session 'highlighting allowing w: marker before projects and contexts' <<EOF
>>> TODOTXT_SIGIL_BEFORE_PATTERN='(w:){0,1}' todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;32m1 (B) [2m+math[0m[0;32m w:[2m+calculus[0m[0;32m (@school or [1m@home)[0m[0;32m integrate [1m@x[0m[0;32m and (@y) and [1m@z[0m[0;32m[0m
2 say thanks and give a [2m+1[0m to [1m@GinaTrapani[0m w:[1m@OtherContributors[0m
--
TODO: 2 of 2 tasks shown
EOF
test_todo_session 'highlighting allowing parentheses around projects and contexts' <<EOF
>>> TODOTXT_SIGIL_BEFORE_PATTERN='\({0,1}' TODOTXT_SIGIL_AFTER_PATTERN='\){0,1}' todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;32m1 (B) [2m+math[0m[0;32m w:+calculus ([1m@school[0m[0;32m or [1m@home[0m[0;32m) integrate [1m@x[0m[0;32m and ([1m@y[0m[0;32m) and [1m@z[0m[0;32m[0m
2 say thanks and give a [2m+1[0m to [1m@GinaTrapani[0m w:@OtherContributors
--
TODO: 2 of 2 tasks shown
EOF
test_todo_session 'highlighting with all customizations for projects and contexts combined' <<EOF
>>> TODOTXT_SIGIL_VALID_PATTERN='.{2,}' TODOTXT_SIGIL_BEFORE_PATTERN='(w:){0,1}(\(){0,1}' TODOTXT_SIGIL_AFTER_PATTERN='\){0,1}' todo.sh -d "$TEST_TODO_LABEL_COLORS" ls
[0;32m1 (B) [2m+math[0m[0;32m w:[2m+calculus[0m[0;32m ([1m@school[0m[0;32m or [1m@home[0m[0;32m) integrate @x and (@y) and @z[0m
2 say thanks and give a +1 to [1m@GinaTrapani[0m w:[1m@OtherContributors[0m
--
TODO: 2 of 2 tasks shown
EOF

test_done
