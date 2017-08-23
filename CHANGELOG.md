# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.10] - 2013-12-06
### Added
- Enable term filtering for listcon.
- Add make install command.
- Enable use of global config file in /etc/todo/config. `make install` installs a global config file.
- Allow use of `post_filter_command` for `listall` and `listpri`.
- Print usage help for custom action and all passed actions.
- Allow configuring null data files (done.txt and report.txt) and don't create
them.
- Color contexts and projects without an add-on, just by setting vars in the
config file.
- Place add-ons in subfolders (for easier git clone).


### Changed
- Handle `-h`, `shorthelp`, and `help` when a Fatal Error happens.
- Properly replace date when replacing task with priority and date.
- Fix `todo_completion` problem with Bash 3.1.
- Improve code commenting/documentation.
- Refactor code for speed/better organization.
- Improve test coverage and test library.

### Removed
- Removed add date from line completion, ie, `todo.sh ls 10[tab]`.


## 4/8/2012 v 2.9

* Added tab auto-completion of projects and contexts from todo.txt and
* done.txt. Type @<Tab> or +<Tab> while entering a task.
* Added new listaddons command displays installed addons.
* List priorities within a range using listpri. For example, to see tasks
* prioritized A-B, use todo.sh listpri A-B
* Fixed various cosmetic issues, bugs, and added developer test library
* enhancements.

## 9/13/2011 v 2.8
* User Enhancements
** listpri/lsp now filters by term. For example, @$ todo.sh lsp A book@ will
only return tasks prioritized A with the word book in them.
** Improved portability for Dropbox or USB key users: If not specified, todo.sh
checks for a config file in its own directory; default todo.txt location is
todo.sh's directory
** Tasks with priority included and auto prepend date on (-t) get the date
where expected. 
** Smarter action completion messaging: do, pri, and depri all let you know if
a task is already done, prioritized, or deprioritized.
** Improved script performance thanks to optimized code
* Developer Enhancements
** Made more parameters available to offer more control to c?ustom actions (-c,
-A, -N, -T)
** Exposed cleaninput() for use in addons
** Custom action output no longer prefaced by TODO: so it's easier to see when
the core script vs. addon is performing an action
** Improved testing framework:
*** Better escaped input handling
*** Abstracted make_action function to test custom action behavior
*** Added tests for source code compliance
*** Cleaner, simpler, modernized, optimized code
* Bugfixes
** listpri complains if specified priority is invalid
** Don't abort task listing when items contain certain escape sequences (\c
\033)
** Condense whitespace ONLY whe task is quoted; automatically convert CRLF to
space
** Added support for todo directory paths with spaces in them
** Don't delete | (pipe) from task input
** -+ and -@ no longer break task coloring if context or project appears at the
end of the line

## 8/3/2010 v 2.7
* Cleanup: help messages, consistent output messages
* Added generalization of the PRI_X color support to all priorities
* Added highlighting of done, but not yet archived tasks via COLOR_DONE
* Exporting die() function for use in custom commands
* 'prepend' and 'replace' actions keep prepended date, 'append' considers
* sentence delimiters
* Color map (BLACK, ...) now supports spaces in the color definitions, making
* it possible to override the default ANSI escape codes with e.g. Conky tags
* (@${color black}@)
* Tests: several regression tests added

## 5/11/2010 v 2.6
* See
* "https://github.com/ginatrapani/todo.txt-cli/compare/v2.5...v2.6":https://github.com/ginatrapani/todo.txt-cli/compare/v2.5...v2.6

##  5/5/2010 v 2.5
* See
* "https://github.com/ginatrapani/todo.txt-cli/compare/v2.4...v2.5":https://github.com/ginatrapani/todo.txt-cli/compare/v2.4...v2.5 

## 5/11/2009 v 2.4
* Cleanup: removing annoying trailing space on pri tasks
* Cleanup: Don't set colors in default todo.cfg.
* Cleanup: Don't set sort command in default todo.cfg.
* Added support for TODOTXT_FINAL_FILTER to provide a final custom list filter
* (a67d0de6254bed5f066e21f1cdcef5bbd8c34ec4)
* Added support for custom sorting (can set in todo.cfg)
* Added parameterize for .todo.actions.d directory
* Bugfix: listcon and listproj now work correctly on Mac OS X 10.5
* Bugfix: pri accepted priorities of more than a single letter
* Bugfix: support commands combination for TODOTXT_SORT_COMMAND; e.g. piped
* commands can be used: export TODOTXT_SORT_COMMAND=" env LC_COLLATE=C sort -f
* -k2 - | grep -m 10  .")
* Bugfix: Replace now echoes old item AND new item, like it used to
* Bugfix: Depri no longer wipes out tasks with more than just the priority in
* parentheses
* Bugfix: Now throws an error if you try to prioritize with more than one
* letter, ie, todo.sh pri AA doesn't work any more.
* Tests: Several regression tests added.

## 4/2/2009 v 2.3
* Separated _list function for reuse by various versions of l

[Unreleased]: https://github.com/todotxt/todo.txt-cli/compare/v2.10...HEAD
[2.10]: https://github.com/todotxt/todo.txt-cli/compare/v2.9...v2.10
