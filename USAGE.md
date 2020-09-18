# [todo.txt-cli](http://todotxt.org) Usage

```shell
todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
```

## Actions

### `add`
Adds THING I NEED TO DO to your todo.txt file on its own line.  

Project and context notation optional.  

Quotes optional.

```shell
todo.sh add "THING I NEED TO DO +project @context"
todo.sh a "THING I NEED TO DO +project @context"
```

### `addm`
Adds FIRST THING I NEED TO DO to your todo.txt on its own line and adds SECOND THING I NEED TO DO to you todo.txt on its own line.

Project and context notation optional.

```shell
todo.sh addm "FIRST THING I NEED TO DO +project1 @context
SECOND THING I NEED TO DO +project2 @context"
```

### `addto`      
Adds a line of text to any file located in the todo.txt directory.

For example, `addto inbox.txt "decide about vacation"`

```shell
todo.sh addto DEST "TEXT TO ADD"
```

### `append`
Adds TEXT TO APPEND to the end of the task on line ITEM#.

Quotes optional.

```shell
todo.sh append ITEM# "TEXT TO APPEND"
todo.sh app ITEM# "TEXT TO APPEND"
```

### `archive`
Moves all done tasks from todo.txt to done.txt and removes blank lines.

```shell
todo.sh archive
```

### `command`
Runs the remaining arguments using only todo.sh builtins.

Will not call any `.todo.actions.d` scripts.

```shell
todo.sh command [ACTIONS]
```

### `deduplicate`
Removes duplicate lines from todo.txt.

```shell
todo.sh deduplicate
```

### `del`
Deletes the task on line ITEM# in todo.txt. If TERM specified, deletes only TERM from the task.

```shell
todo.sh del ITEM# [TERM]
todo.sh rm ITEM# [TERM]
```

### `depri`
Deprioritizes (removes the priority) from the task(s) on line ITEM# in todo.txt.

```shell
todo.sh depri ITEM#[, ITEM#, ITEM#, ...]
todo.sh dp ITEM#[, ITEM#, ITEM#, ...]
```

### `do`
Marks task(s) on line ITEM# as done in todo.txt.

```shell
todo.sh do ITEM#[, ITEM#, ITEM#, ...]
```

### `help`
Display help about usage, options, built-in and add-on actions, or just the usage help for the passed ACTION(s).

```shell
todo.sh help [ACTION...]
```

### `list`
Displays all tasks that contain TERM(s) sorted by priority with line numbers.  Each task must match all TERM(s) (logical AND); to display tasks that contain any TERM (logical OR), use `"TERM1\|TERM2\|..."` (with quotes), or `TERM1\\|TERM2` (unquoted). Hides all tasks that contain TERM(s) preceded by a minus sign (i.e. `-TERM`). 

If no TERM specified, lists entire todo.txt.
​    
```shell
todo.sh list [TERM...]
todo.sh ls [TERM...]
```

### `listall`
Displays all the lines in todo.txt AND done.txt that contain TERM(s) sorted by priority with line  numbers. Hides all tasks that contain TERM(s) preceded by a minus sign (i.e. `-TERM`).

If no TERM specified, lists entire todo.txt AND done.txt concatenated and sorted.

```shell
todo.sh listall [TERM...]
todo.sh lsa [TERM...]
```

### `listaddons`
Lists all added and overridden actions in the actions directory.

```shell
todo.sh listaddons
```

### `listcon`
Lists all the task contexts that start with the @ sign in todo.txt.

If TERM specified, considers only tasks that contain TERM(s).

```shell
todo.sh listcon [TERM...]
todo.sh lsc [TERM...]
```

### `listfile`
Displays all the lines in SRC file located in the todo.txt directory, sorted by priority with line  numbers. If TERM specified, lists all lines that contain TERM(s) in SRC file. Hides all tasks that contain TERM(s) preceded by a minus sign (i.e. `-TERM`).

Without any arguments, the names of all text files in the todo.txt directory are listed.

```shell
todo.sh listfile [SRC [TERM...]]
todo.sh lf [SRC [TERM...]]
```

### `listpri`
Displays all tasks prioritized PRIORITIES. PRIORITIES can be a single one (A) or a range (A-C). If no PRIORITIES specified, lists all prioritized tasks. If TERM specified, lists only prioritized tasks that contain TERM(s). Hides all tasks that contain TERM(s) preceded by a minus sign (i.e. `-TERM`).

```shell
todo.sh listpri [PRIORITIES] [TERM...]
todo.sh lsp [PRIORITIES] [TERM...]
```

### `listproj`
Lists all the projects (terms that start with a `+` sign) in todo.txt. If TERM specified, considers only tasks that contain TERM(s).

```shell
todo.sh listproj [TERM...]
todo.sh lsprj [TERM...]
```

### `move`
Moves a line from source text file (SRC) to destination text file (DEST). Both source and destination file must be located in the directory defined in the configuration directory. When SRC is not defined it's by default todo.txt.

```shell
todo.sh move ITEM# DEST [SRC]
todo.sh mv ITEM# DEST [SRC]
```

### `prepend`
Adds TEXT TO PREPEND to the beginning of the task on line ITEM#. Quotes optional.

```shell
todo.sh prepend ITEM# "TEXT TO PREPEND"
todo.sh prep ITEM# "TEXT TO PREPEND"
```

### `pri`
Adds PRIORITY to task on line ITEM#.  If the task is already prioritized, replaces current priority with new PRIORITY. PRIORITY must be a letter between A and Z.

```shell
todo.sh pri ITEM# PRIORITY
todo.sh p ITEM# PRIORITY
```

### `replace`
Replaces task on line ITEM# with UPDATED TODO.

```shell
todo.sh replace ITEM# "UPDATED TODO"
```

### `report`
Adds the number of open tasks and done tasks to report.txt.

```shell
todo.sh report
```

### `shorthelp`
List the one-line usage of all built-in and add-on actions.

```shell
todo.sh shorthelp
```


## Options

### `-@`
Hide context names in list output. Use twice to show context names (default).

### `-+`
Hide project names in list output. Use twice to show project names (default).

### `-c`
Color mode

### `-d CONFIG_FILE`
Use a configuration file other than the default `~/.todo/config`

### `-f`
Forces actions without confirmation or interactive input.

### `-h`
Display a short help message; same as action "shorthelp"

### `-p`
Plain mode turns off colors

### `-P`
Hide priority labels in list output. Use twice to show priority labels (default).

### `-a`
Don't auto-archive tasks automatically on completion

### `-A`
Auto-archive tasks automatically on completion

### `-n`
Don't preserve line numbers; automatically remove blank lines on task deletion.

### `-N`
Preserve line numbers

### `-t`
Prepend the current date to a task automatically when it's added.

### `-T`
Do not prepend the current date to a task automatically when it's added.

### `-v`
Verbose mode turns on confirmation messages

### `-vv`
Extra verbose mode prints some debugging information and additional help text

### `-V`
Displays version, license and credits

### `-x`
Disables `TODOTXT_FINAL_FILTER`
