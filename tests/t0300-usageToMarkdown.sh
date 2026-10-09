#!/usr/bin/env bash
#

test_description='usageToMarkdown sanity check

This test covers the basic conversion of the usage output to Markdown format.
'
. ./test-lib.sh

cat > demo-usage.txt <<'EOF'
  Usage: todo.sh [-cd] action

  Options:
    -c
        Color mode
    -d
        Dummy, one of:
          one
          two
          three

  Environment variables:
    TODOTXT_AUTO_COLOR              is same as option -c
    TODOTXT_LONG_CONFIG='value is also long so description is on new line'
                                    this configuration can do
                                    a lot of things
    TODOTXT_CONFIG_WITH_VALUE=xxx   default value xxx

  Built-in Actions:
    add "hello, world"
    a "hello, world"
      Adds hello, world to the todo.txt file.
      Quotes optional.

    addm "hello
    world"
      Another way to add hello, world to the todo.txt file.

    archive
      Archives completed hellos to ~/archive
EOF

test_todo_session 'usageToMarkdown conversion' <<'EOF'
>>> cat demo-usage.txt | ../../usageToMarkdown
# [todo.txt-cli](http://todotxt.org) Usage
\
```
  Usage: todo.sh [-cd] action
```
\
## Options
### -c
\
Color mode
### -d
\
Dummy, one of:
* one
* two
* three
\
## Environment variables
### TODOTXT\_AUTO\_COLOR
\
is same as option -c
\
### TODOTXT\_LONG\_CONFIG
\
```shell
TODOTXT_LONG_CONFIG='value is also long so description is on new line'
```
\
\
\
this configuration can do
a lot of things
### TODOTXT\_CONFIG\_WITH\_VALUE
\
```shell
TODOTXT_CONFIG_WITH_VALUE=xxx
```
\
default value xxx
\
\
## Built-in Actions
### add
\
```shell
$ todo.sh add "hello, world"
$ todo.sh a "hello, world"
```
\
Adds hello, world to the todo.txt file.
Quotes optional.
\
### addm
\
```shell
$ todo.sh addm "hello
world"
```
\
Another way to add hello, world to the todo.txt file.
\
### archive
\
```shell
$ todo.sh archive
```
Archives completed hellos to ~/archive
EOF

test_done
