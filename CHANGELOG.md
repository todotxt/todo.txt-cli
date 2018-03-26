# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.11.0] - 2018-03-26
### Added
- Added support for `$XDG_CONFIG_HOME` config file/actions location
- Created [CODE_OF_CONDUCT.md](/CODE_OF_CONDUCT.md) ([#217])
- Created [CHANGELOG.md](/CHANGELOG.md) ([#218])


### Changed
- Updated `add` command to accept lowercase priority ([#230])
- Clean tests and version file in Makefile. Don't ignore errors in tests.
- Updated [README.md](/README.md) ([#219])
- Update Downloads links to point at the Releases page ([#228])
- Set the executable bit when preparing releases ([#156])

### Fixes 
- Update links to use https
- Suppress todo.sh error messages when invoked during completion ([#8])


## [2.10.0] - 2013-12-06
### Added
- Enable term filtering for listcon.
- Add make install command.
- Enable use of global config file in `/etc/todo/config`. `make install` installs a global config file.
- Allow use of `post_filter_command` for `listall` and `listpri`.
- Print usage help for custom action and all passed actions.
- Allow configuring null data files (done.txt and report.txt) and don't create
  them.
- Color contexts and projects without an add-on, just by setting vars in the
  config file.
- Place add-ons in subfolders (for easier git clone).

### Changed
- Improve code commenting/documentation.
- Refactor code for speed/better organization.
- Improve test coverage and test library.

### Removed
- Removed add date from line completion, ie, `todo.sh ls 10[tab]`.

### Fixed
- Properly replace date when replacing task with priority and date.
- Handle `-h`, `shorthelp`, and `help` when a Fatal Error happens.
- Fix `todo_completion` problem with Bash 3.1.

## [2.9.0] - 2012-04-08
### Added
- Added tab auto-completion of projects and contexts from `todo.txt` and `done.txt`. Type `@<Tab>` or `+<Tab>` while entering a task.
- Added new listaddons command displays installed addons.
- List priorities within a range using listpri. For example, to see tasks prioritized A-B, use `todo.sh listpri A-B`

### Fixed
- Fixed various cosmetic issues, bugs, and added developer test library enhancements.


## [2.8.0] - 2011-09-13
### Added
- `listpri`/`lsp` now filters by term. For example, `todo.sh lsp A book` will only return tasks prioritized `A` with the word book in them.
- Added support for todo directory paths with spaces in them.
- Tasks with priority included and auto prepend date on (`-t`) get the date where expected. 
- Smarter action completion messaging: `do`, `pri`, and `depri` all let you know if a task is already done, prioritized, or deprioritized.
- Made more parameters available to offer more control to custom actions (`-c`, `-A`, `-N`, `-T`)

### Changed
- Improved portability for Dropbox or USB key users. If not specified, todo.sh checks for a config file in its own directory; default todo.txt location is todo.sh's directory.
- Improved script performance thanks to optimized code
- Exposed `cleaninput()` for use in addons
- Improved testing framework:
  - Better escaped input handling
  - Abstracted make_action function to test custom action behavior
  - Added tests for source code compliance
  - Cleaner, simpler, modernized, optimized code

### Fixed
- Custom action output no longer prefaced by `TODO:` so it's easier to see when the core script vs. addon is performing an action
- `listpri` complains if specified priority is invalid
- Don't abort task listing when items contain certain escape sequences (`\c \033`)
- Condense whitespace ONLY whe task is quoted; automatically convert CRLF to space
- Don't delete `|` (pipe) from task input
- `-+` and `-@` no longer break task coloring if context or project appears at the end of the line


## [2.7.0] - 2010-08-03
### Added
- Added generalization of the _PRI_X_ color support to all priorities
- Added highlighting of done, but not yet archived tasks via *COLOR_DONE*
- Color map (BLACK, ...) now supports spaces in the color definitions, making it possible to override the default ANSI escape codes with e.g. Conky tags (`${color black}`)

### Changed
- Cleanup: help messages, consistent output messages
- Exporting `die()` function for use in custom commands
- `prepend` and `replace` actions keep prepended date, `append` considers sentence delimiters
- Tests: several regression tests added

## [2.6.0] - 2010-05-11
### Added
- Added a case for the fixed replace command.

### Changed
- Changed odd tabs to spaces.
- Faster help/useage document outputs.
- Consolidated `TODOTXT_VERBOSE` tests.
- Refactored various add functionality to one function.
- Updated `_list()` output to match updated `addto`.

### Fixed
- Quoting regexp to parse properly.
- Fixed erroneous hide/show comments.
- Correctly fixed regexp quoting issue for bash v3.1.x and v3.2.x.
- Old versions of bash do not have `=~`
- Fix line endings.
- Fixed bug for replace command.

## [2.5.0] - 2010-05-05
### Added
- Support use of `$HOME/.todo/` for all todo.sh configuration
- Added new multiple do capability to help message
- Added option to disable final filter
- Added a new variable `$TODO_FULL_SH`
- Added new action `addm`
- Added support PAGER pipe for help output
- Added some additional mappings, plus a project context

### Changed
- Added 'silent' to a bunch of calls

### Fixed
- Fixing prepend and priority issue.
- Replace with `priority` set
- Multiple `do` items
- `prepend` not correct on prioritized tasks
- Invalid date range.  Changed regex `[ -~]` to `[ ~-]`.
- `do`: no safeguard to `do` twice. Tests item is not marked done before attempting to mark item as "done".
- Fixed `add` does not escape line breaks
- `append` and `replace` unexpected behavior if there's an `&` in task (even in quotes)
- Tasks whose `ID` begins with `0` ought to be ignored.
- Fixed auto-complete function name for contexts


## [2.4.0] - 2009-05-11
### Added
- Added support for `TODOTXT_FINAL_FILTER` to provide a final custom list filter.
- Added support for custom sorting (can set in `todo.cfg`)
- Added parameterize for `.todo.actions.d` directory

### Removed
- Removed annoying trailing space on `pri` tasks
- Don't set colors in default `todo.cfg`.
- Don't set sort command in default `todo.cfg`.

### Fixed
- `listcon` and `listproj` now work correctly on Mac OS X 10.5
- `pri` accepted priorities of more than a single letter
- Support commands combination for `TODOTXT_SORT_COMMAND`; e.g. piped commands can be used: `export TODOTXT_SORT_COMMAND=" env LC_COLLATE=C sort -f -k2 - | grep -m 10  ."`
- Replace now echoes old item AND new item, like it used to.
- `depri` no longer wipes out tasks with more than just the priority in parentheses
- Now throws an error if you try to prioritize with more than one letter, ie, `todo.sh pri AA` doesn't work any more.

## [2.3.0] - 2009-04-02
### Added
- Added hide priority, context, and projects options now enabled `-P`, `-@` and `-+`
- Enabled recursive call of todo.sh from add-ons
- Exported variables for use in add-ons
- Added `-vv` option for debugging output
- Added short usage statement (that fits on one screen) with `-h`
- Added Makefile dist infrastructure for versioned releases in Downloads area on GitHub

### Changed
- Separated `_list` function for reuse by various versions of list command to reduce duplicate code
- Set `ls` as the default action


## [2.2.0] - 2009-03-??
### Fixed
- For awhile here during the GitHub transition, we stripped the version number from todo.sh and updated it kind of willy-nilly, so we're back-versioning all unversioned copies v 2.2.


## [2.1.0] - 2009-02-23
### Added
- Added "pluggability" with `~/.todo.actions.d/` support (via [Tammy and Ed](http://tech.groups.yahoo.com/group/todotxt/message/1739))
- Added `-t` param, off by default. When specified, it automatically prepends the current date to new todo's on add
- Searches for more Unix-y `~/.todo.cfg` if `~/todo.cfg` doesn't exist (via [Ed](http://tech.groups.yahoo.com/group/todotxt/message/1767))

### Fixed
- Corrected "ambiguous redirect" bug with done file (via [Jeff](http://tech.groups.yahoo.com/group/todotxt/message/1764))
- Corrected usage and help message with new params
- Corrected config file miscomment about colors


## [2.0.1] - 2009-02-17
### Fixed
- Restored `-d` parameter functionality broken in 2.0 (d'oh, thanks Jason, you made the changelog! )


## [2.0.0] - 2009-02-17
### Added
- Added `addto [DEST] "Text to add"` will append text to any file in the todo directory, like `ideas.txt` or `maybelater.txt`.
- Added `mv # [DEST]` will move a task from `todo.txt` to another file `[DEST]` in the todo directory, like if you decide your `"Learn French"` task should go into your `maybelater.txt` file.
- `depri #` removes priority from a task.
- `rm # [TERM]` or `del # [TERM]` will delete just the `[TERM]` from the task on line # in todo.txt.
- `listfile [SRC] [TERM]` or `lf [SRC] [TERM]` will list the contents of any text file in the todo directory, and filter by keyword `[TERM]`.
- `listcon` (`lsc`) and `listproj` (`lsprj`) lists contexts and projects, respectively, that appear in todo.txt. (Requires `gawk`)
- On task deletion, line number preservation is on by default (known issue, leaves blank lines). Optional, can be turned off with `-n` option.
- Auto-archive on task completion is now on by default; can be turned off with `-a` parameter.

### Changed
- Separated config file into a non hidden dot file.

### Fixed
- Better error handling throughout for all commands.
- Archive now defrags the file (removes blank lines; see line preservation option.)
- Using `/bin/bash` instead of `/bin/sh`


## [1.7.3] - 2006-07-29
### Added
- Added short action aliases – `add/a`, `list/ls`, `listpri/lsp`, `listall/lsa`, `prepend/prep`, `append/app`, `del/rm`


## [1.7.2] - 2006-07-28
### Added
- `listpri` automatically capitalizes lowercase priorities
- `listpri` now displays friendly error message, and the # of tasks returned in verbose mode

### Changed
- `do` action removes priority from task automatically
  Update:

### Fixed
- Actions are now case-insensitive (ie, `todo.sh Add` will work)


## [1.7.1] - 2006-07-21
### Changed
- I'm a big dummy and didn't keep track of what I fixed here. Sorry!


## [1.7.0] - 2006-07-19
### Added
- Interactive `add`, `append`, `prepend`, and `replace` (tx, Ben!)
- Action `listall` displays tasks from both todo.txt and done.txt
- Option `-f` forces delete action and disables interactive input (for todobot.pl)
- Option `-h` displays full help message.

### Deprecated
- Option `-q` deprecated; Use `-v` to turn on verbose mode

### Changed
- A very short version of usage message displays by default instead of the long version.
- Comment in info about `.todo` file being required

### Fixed
- No colors display for done tasks (tx, Tanja!)
- Sort is now case-insensitive (tx, Lonnie!)


## [1.6.3] - 2006-07-06
### Added
- Line numbers now padded, up to 100 characters. (tx, Tanja!)


## [1.6.2] - 2006-07-05
### Fixed
- Windows config files with spaces now work (tx Ron)


## [1.6.1] - 2006-07-05
### Changed
- The default location of your `.todo` file is now `$HOME/.todo`

### Fixed
- No colors mode (`-p`) now works as expected


## [1.6.0] - 2006-07-04
### Added
- Action `prepend` adds text to an item at the beginning of the line.
- Configuration file is now separated from script into `.todo` file
- Specify a config file other than `.todo` using the `-d` option
- Option `-q` quiets todo.sh's chattiness.
- Option `-V` shows version and license information.

### Changed
- The option to turn off colors is now `-p` (no longer `-nc` as in 1.5.2)


## [1.5.2] - 2006-06-26
### Fixed
- Items that start with `x ` (an x with a space after) are archived now to avoid lines that start with a word like `xander` from being archived. (tx, Tannie!)
- Report now only archives items that start with `x ` as well.


## [1.5.1] - 2006-06-26
### Fixed
- Items with an `x` in them at all were being deleted on archive with 1.5; all fixed now.


## [1.5.0] - 2006-06-24
### Added
- Option to turn off colors (to avoid characters in piped text files or IM bot), ie `todo.sh -nc [COMMAND]`
- A date is added to a completed todo, ie `x 2006-06-24` (tx SETH)
- Action `remdup` removes exact duplicate lines from todo.txt (tx Tannie)
- Action `del` removes any blank lines from todo.txt (tx Tannie)

### Changed
- Using `sed -i` instead of copying tmp file (tx Tannie)

### Fixed
- Colors show in OS/X 10.4 (tx SETH & misha)


## [1.4.0] - 2006-06-17
### Added
- Tasks are color-coded by priority in Cygwin (Thanks, Abraham, Manuel and Luis!)

### Changed
- Switched endless `if-then` to a `case` statement, and tightened up `wc -l` regex. (Thanks, Sash!)

### Fixed
- If you `replace`/`do`/`append` to a non-existent task, your todo.txt is no longer overwritten and the error is handled gracefully. (Thanks, Scott!)


## [1.3.0] - 2006-05-29
### Added
- Displays the number of newly added todo (Thanks, Amy!)
- Confirms whether or not you really want to delete a todo
- Displays success messages and confirmations on `append`, `replace`, `do`, etc.
- Added licensing information in comments. GPL, baby!

### Changed
- Alphabetized command workflow in if/then construction
- Tightened up `sed` commands, removed unnecessary `grep`s and `cat`s (Thanks, Sash!)
- Stripped whitespace around number lines from wc results

### Removed
- Removed filenames from `report.txt` format, for easier graphing or Excel imports.

### Fixed
- Todos are now sorted alphabetically when listed by a term. (ie: `todo list flowers)


## [1.2.0] - 2006-05-15
### Added
- `list` is case insenstive. ie, `todo list Mac` will match lines with "mac" and "Mac"

### Changed
- `todo list` matches multiple [TERM]s. ie, `todo list mac offline` will match all lines that contain the words "mac" and "offline"
- `repri` and `pri` actions combined into `pri` action (Thanks Mike!)
- Quotes no longer required with `add` and `replace` (Thanks Karl!)
- Any priority added to a todo must be uppercase to preserve sort order, enforced now. ie `todo pri 1 a` will return a usage error.

### Fixed
- File "sanity checks" and cleanup function, test script and various fantastic stylistic improvements added. Extra big thanks to Karl!


## [1.1.0] - 2006-05-12
### Added
- Supports file paths with spaces (ie `C:\Documents and Settings\gina\todo.txt`)


## 1.0.0 - 2006-05-11
### Added
- Consolidated into one master script with usage notes and released.


[Unreleased]: https://github.com/todotxt/todo.txt-cli/compare/v2.11.0...HEAD
[2.11.0]: https://github.com/todotxt/todo.txt-cli/compare/v2.10.0...v2.11.0
[2.10.0]: https://github.com/todotxt/todo.txt-cli/compare/v2.9.0...v2.10.0
[2.9.0]: https://github.com/todotxt/todo.txt-cli/compare/v2.8.0...v2.9.0
[2.8.0]: https://github.com/todotxt/todo.txt-cli/compare/v2.7.0...v2.8.0
[2.7.0]: https://github.com/todotxt/todo.txt-cli/compare/v2.6.0...v2.7.0
[2.6.0]: https://github.com/todotxt/todo.txt-cli/compare/v2.5.0...v2.6.0
[2.5.0]: https://github.com/todotxt/todo.txt-cli/compare/v2.4.0...v2.5.0
[2.4.0]: https://github.com/todotxt/todo.txt-cli/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/todotxt/todo.txt-cli/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/todotxt/todo.txt-cli/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/todotxt/todo.txt-cli/compare/v2.0.1...v2.1.0
[2.0.1]: https://github.com/todotxt/todo.txt-cli/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/todotxt/todo.txt-cli/compare/v1.7.3...v2.0.0
[1.7.3]: https://github.com/todotxt/todo.txt-cli/compare/v1.7.2...v1.7.3
[1.7.2]: https://github.com/todotxt/todo.txt-cli/compare/v1.7.1...v1.7.2
[1.7.1]: https://github.com/todotxt/todo.txt-cli/compare/v1.7.0...v1.7.1
[1.7.0]: https://github.com/todotxt/todo.txt-cli/compare/v1.6.3...v1.7.0
[1.6.3]: https://github.com/todotxt/todo.txt-cli/compare/v1.6.2...v1.6.3
[1.6.2]: https://github.com/todotxt/todo.txt-cli/compare/v1.6.1...v1.6.2
[1.6.1]: https://github.com/todotxt/todo.txt-cli/compare/v1.6.0...v1.6.1
[1.6.0]: https://github.com/todotxt/todo.txt-cli/compare/v1.5.2...v1.6.0
[1.5.2]: https://github.com/todotxt/todo.txt-cli/compare/v1.5.1...v1.5.2
[1.5.1]: https://github.com/todotxt/todo.txt-cli/compare/v1.5.0...v1.5.1
[1.5.0]: https://github.com/todotxt/todo.txt-cli/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/todotxt/todo.txt-cli/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/todotxt/todo.txt-cli/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/todotxt/todo.txt-cli/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/todotxt/todo.txt-cli/compare/v1.0.0...v1.1.0

[#230]: https://github.com/todotxt/todo.txt-cli/pull/230
[#228]: https://github.com/todotxt/todo.txt-cli/pull/228
[#219]: https://github.com/todotxt/todo.txt-cli/pull/219
[#218]: https://github.com/todotxt/todo.txt-cli/pull/218
[#217]: https://github.com/todotxt/todo.txt-cli/pull/217
[#156]: https://github.com/todotxt/todo.txt-cli/pull/156
[#8]: https://github.com/todotxt/todo.txt-cli/pull/8
