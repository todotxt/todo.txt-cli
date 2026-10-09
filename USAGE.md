# [todo.txt-cli](http://todotxt.org) Usage

```
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
```

## Options
### -@

Hide context names in list output.  Use twice to show context
names (default).
### -+

Hide project names in list output.  Use twice to show project
names (default).
### -c

Color mode
### -d CONFIG\_FILE

Use a configuration file other than one of the defaults:
* ~/.todo/config
* ~/todo.cfg
* ~/.todo.cfg
* ~/.config/todo/config
* ./todo.cfg
* /etc/todo/config

### -f

Forces actions without confirmation or interactive input
### -h

Display a short help message; same as action "shorthelp"
### -p

Plain mode turns off colors
### -P

Hide priority labels in list output.  Use twice to show
priority labels (default).
### -a

Don't auto-archive tasks automatically on completion
### -A

Auto-archive tasks automatically on completion
### -n

Don't preserve line numbers; automatically remove blank lines
on task deletion
### -N

Preserve line numbers
### -t

Prepend the current date to a task automatically
when it's added.
### -T

Do not prepend the current date to a task automatically
when it's added.
### -v

Verbose mode turns on confirmation messages
### -vv

Extra verbose mode prints some debugging information and
additional help text
### -V

Displays version, license and credits
### -x

Disables TODOTXT\_FINAL\_FILTER

## Built-in Actions
### add

```shell
$ todo.sh add "(B) THING I NEED TO DO +project @context"
$ todo.sh a "(B) THING I NEED TO DO +project @context"
```

Adds THING I NEED TO DO to your todo.txt file on its own line.
Priority (B), +project and @context notation optional.
Quotes optional.

### addm

```shell
$ todo.sh addm "FIRST THING I NEED TO DO +project1 @context
(C) SECOND THING I NEED TO DO +project2 @context"
```

Adds FIRST THING I NEED TO DO to your todo.txt on its own line and
Adds SECOND THING I NEED TO DO to you todo.txt on its own line.
Priority (C), +project and @context notation optional.

### addto

```shell
$ todo.sh addto DEST "TEXT TO ADD"
```
Adds a line of text to any file located in the todo.txt directory.
For example, addto inbox.txt "decide about vacation"

### append

```shell
$ todo.sh append NR "TEXT TO APPEND"
$ todo.sh app NR "TEXT TO APPEND"
```

Adds TEXT TO APPEND to the end of the task on line NR.
Quotes optional.

### archive

```shell
$ todo.sh archive
```
Moves all done tasks from todo.txt to done.txt and removes blank lines.

### command

```shell
$ todo.sh command [ACTIONS]
```
Runs the remaining arguments using only todo.sh builtins.
Will not call any TODO\_ACTIONS\_DIR (~/.todo/actions) scripts.

### deduplicate

```shell
$ todo.sh deduplicate
```
Removes duplicate lines from todo.txt.

### del

```shell
$ todo.sh del NR [TERM]
$ todo.sh rm NR [TERM]
```

Deletes the task on line NR in todo.txt.
If TERM specified, deletes only TERM from the task.

### depri

```shell
$ todo.sh depri NR [NR ...]
$ todo.sh dp NR [NR ...]
```

Deprioritizes (removes the priority) from the task(s)
on line NR in todo.txt.

### done

```shell
$ todo.sh done NR [NR ...]
$ todo.sh do NR [NR ...]
```

Marks task(s) on line NR as done in todo.txt.

### help

```shell
$ todo.sh help [ACTION...]
```
Display help about usage, options, built-in and add-on actions,
or just the usage help for the passed ACTION(s).

### list

```shell
$ todo.sh list [TERM...]
$ todo.sh ls [TERM...]
```

Displays all tasks that contain TERM(s) sorted by priority with line
numbers.  Each task must match all TERM(s) (logical AND); to display
tasks that contain any TERM (logical OR), use
'TERM1\\|TERM2\\|...' (with quotes), or TERM1\\\\\\|TERM2 (unquoted).
Hides all tasks that contain TERM(s) preceded by a
minus sign (i.e. -TERM).
TERM(s) are grep-style basic regular expressions; for literal matching,
put a single backslash before any [ ] \\ $ * . ^ and enclose the entire
TERM in single quotes, or use double backslashes and extra shell-quoting.
If no TERM specified, lists entire todo.txt.

### listall

```shell
$ todo.sh listall [TERM...]
$ todo.sh lsa [TERM...]
```

Displays all the lines in todo.txt AND done.txt that contain TERM(s)
sorted by priority with line numbers.  Hides all tasks that
contain TERM(s) preceded by a minus sign (i.e. -TERM).  If no
TERM specified, lists entire todo.txt AND done.txt
concatenated and sorted.

### listaddons

```shell
$ todo.sh listaddons
```
Lists all added and overridden actions in the actions directory.

### listcon

```shell
$ todo.sh listcon [TERM...]
$ todo.sh lsc [TERM...]
```

Lists all the task contexts that start with the @ sign in todo.txt.
If TERM specified, considers only tasks that contain TERM(s).

### listfile

```shell
$ todo.sh listfile [SRC [TERM...]]
$ todo.sh lf [SRC [TERM...]]
```

Displays all the lines in SRC file located in the todo.txt directory,
sorted by priority with line numbers.  If TERM specified, lists
all lines that contain TERM(s) in SRC file.  Hides all tasks that
contain TERM(s) preceded by a minus sign (i.e. -TERM).
Without any arguments, the names of all text files in the todo.txt
directory are listed.

### listpri

```shell
$ todo.sh listpri [PRIORITIES] [TERM...]
$ todo.sh lsp [PRIORITIES] [TERM...]
```

Displays all tasks prioritized PRIORITIES.
PRIORITIES can be a [concatenation of] single (A) or range (A-C).
If no PRIORITIES specified, lists all prioritized tasks.
If TERM specified, lists only prioritized tasks that contain TERM(s).
Hides all tasks that contain TERM(s) preceded by a minus sign
(i.e. -TERM).

### listproj

```shell
$ todo.sh listproj [TERM...]
$ todo.sh lsprj [TERM...]
```

Lists all the projects (terms that start with a + sign) in
todo.txt.
If TERM specified, considers only tasks that contain TERM(s).

### move

```shell
$ todo.sh move NR DEST [SRC]
$ todo.sh mv NR DEST [SRC]
```

Moves the line NR from source file (SRC) to destination file (DEST).
Both files must be located in the todo.txt directory. SRC defaults to
todo.txt.

### prepend

```shell
$ todo.sh prepend NR "TEXT TO PREPEND"
$ todo.sh prep NR "TEXT TO PREPEND"
```

Adds TEXT TO PREPEND to the beginning of the task on line NR.
Quotes optional.

### pri

```shell
$ todo.sh pri NR PRIORITY
$ todo.sh p NR PRIORITY
```

Adds PRIORITY to task on line NR.  If the task is already
prioritized, replaces current priority with new PRIORITY.
PRIORITY must be a letter between A and Z.

### replace

```shell
$ todo.sh replace NR "UPDATED TODO"
```
Replaces task on line NR with UPDATED TODO.

### report

```shell
$ todo.sh report
```
Adds the number of open tasks and done tasks to report.txt.

### shorthelp

```shell
$ todo.sh shorthelp
```
List the one-line usage of all built-in and add-on actions.

