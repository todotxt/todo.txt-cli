# [![todo.txt-cli](http://todotxt.org/images/todotxt_logo_2012.png)](http://todotxt.org)

> A simple and extensible shell script for managing your todo.txt file.

[![Build Status](https://travis-ci.org/todotxt/todo.txt-cli.svg?branch=master)](https://travis-ci.org/todotxt/todo.txt-cli)
[![GitHub issues](https://img.shields.io/github/issues/todotxt/todo.txt-cli.svg)](https://github.com/todotxt/todo.txt-cli/issues) 
[![GitHub forks](https://img.shields.io/github/forks/todotxt/todo.txt-cli.svg)](https://github.com/todotxt/todo.txt-cli/network)
[![GitHub stars](https://img.shields.io/github/stars/todotxt/todo.txt-cli.svg)](https://github.com/todotxt/todo.txt-cli/stargazers)
[![GitHub license](https://img.shields.io/github/license/todotxt/todo.txt-cli.svg)](https://raw.githubusercontent.com/todotxt/todo.txt-cli/master/LICENSE)
[![Gitter](https://badges.gitter.im/join_chat.svg)](https://gitter.im/todotxt/todo.txt-cli)

> Gif

*Read our [contributing guide](contributing.md) if you're looking to contribute (issues/PRs/etc).*

## Installation

### OS X / macOS

#### Via [brew](https://brew.sh/)

```console
$ brew install todo-txt
```

## Usage

### Format
```console
todo.sh [-fhpqvV] [-d todo_config] action [task_number] [task_description]
```
### Actions

#### Add
Adds THING I NEED TO DO to your todo.txt file on its own line. Project and context notation optional. Quotes optional.

```console
todo.sh add "THING I NEED TO DO +project @context" 
todo.sh a "THING I NEED TO DO +project @context" 
```

#### Add To
Adds a line of text to any file located in the todo.txt directory. 

```console
todo.sh addto inbox.txt "decide about vacation"
```

#### Append
Adds TEXT TO APPEND to the end of the todo on line NUMBER. Quotes optional.

```console
todo.sh append NUMBER "TEXT TO APPEND"
app NUMBER "TEXT TO APPEND"
```

```
archive
  Moves done items from todo.txt to done.txt and removes blank lines.

del NUMBER [TERM]
rm NUMBER [TERM]
  Deletes the item on line NUMBER in todo.txt.  
  If term specified, deletes only the term from the line.

depri NUMBER 
dp NUMBER
  Deprioritizes (removes the priority) from the item 
on line NUMBER in todo.txt.  

do NUMBER
  Marks item on line NUMBER as done in todo.txt.

list [TERM...] 
ls [TERM...]
  Displays all todo's that contain TERM(s) sorted by priority with line
  numbers.  If no TERM specified, lists entire todo.txt.

listall [TERM...]
lsa [TERM...]
  Displays all the lines in todo.txt AND done.txt that contain TERM(s)
  sorted by priority with line  numbers.  If no TERM specified, lists
  entire todo.txt AND done.txt concatenated and sorted.

listcon
lsc
  Lists all the task contexts that start with the @ sign in todo.txt.

listfile SRC [TERM...]
lf SRC [TERM...]
  Displays all the lines in SRC file located in the todo.txt directory,
  sorted by priority with line  numbers.  If TERM specified, lists
  all lines that contain TERM in SRC file.

listpri [PRIORITY]
lsp [PRIORITY]
  Displays all items prioritized PRIORITY.
  If no PRIORITY specified, lists all prioritized items.

listproj
lsprj
  Lists all the projects that start with the + sign in todo.txt.

move NUMBER DEST [SRC]
mv NUMBER DEST [SRC]
  Moves a line from source text file (SRC) to destination text file (DEST).
  Both source and destination file must be located in the directory defined
  in the configuration directory.  When SRC is not defined 
it's by default todo.txt.

prepend NUMBER "TEXT TO PREPEND"
prep NUMBER "TEXT TO PREPEND"
  Adds TEXT TO PREPEND to the beginning of the todo on line NUMBER.
  Quotes optional.

pri NUMBER PRIORITY
p NUMBER PRIORITY
  Adds PRIORITY to todo on line NUMBER.  If the item is already
  prioritized, replaces current priority with new PRIORITY.
  PRIORITY must be an uppercase letter between A and Z.

replace NUMBER "UPDATED TODO"
  Replaces todo on line NUMBER with UPDATED TODO.

report
  Adds the number of open todo's and closed done's to report.txt.


## Options:
```console
-d CONFIG_FILE
    Use a configuration file other than the default ~/todo.cfg
-f
    Forces actions without confirmation or interactive input
-h
    Display this help message
-p
    Plain mode turns off colors
-a
    Don't auto-archive tasks automatically on completion
-n
    Don't preserve line numbers; automatically remove blank lines 
    on task deletion
-v 
    Verbose mode turns on confirmation messages
-V 
    Displays version, license and credits
```
