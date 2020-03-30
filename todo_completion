#!/bin/bash source-this-script
[ "$BASH_VERSION" ] || return

_todo()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    local -r OPTS="-@ -@@ -+ -++ -d -f -h -p -P -PP -a -n -t -v -vv -V -x"
    local -r COMMANDS="\
        add a addto addm append app archive command del  \
        rm depri dp do help list ls listaddons listall lsa listcon  \
        lsc listfile lf listpri lsp listproj lsprj move \
        mv prepend prep pri p replace report shorthelp"
    local -r MOVE_COMMAND_PATTERN='move|mv'

    local _todo_sh=${_todo_sh:-todo.sh}
    local completions
    if [ $COMP_CWORD -eq 1 ]; then
        completions="$COMMANDS $(eval TODOTXT_VERBOSE=0 $_todo_sh command listaddons 2>/dev/null) $OPTS"
    elif [[ $COMP_CWORD -gt 2 && ( \
        "${COMP_WORDS[COMP_CWORD-2]}" =~ ^($MOVE_COMMAND_PATTERN${_todo_file2_actions:+|${_todo_file2_actions}})$ || \
        "${COMP_WORDS[COMP_CWORD-3]}" =~ ^($MOVE_COMMAND_PATTERN${_todo_file3_actions:+|${_todo_file3_actions}})$ ) ]]; then
        # "move ITEM# DEST [SRC]" has file arguments on positions 2 and 3.
        completions=$(eval TODOTXT_VERBOSE=0 $_todo_sh command listfile 2>/dev/null)
    else
        case "$prev" in
            command)
                completions=$COMMANDS;;
            help)
                completions="$COMMANDS $(eval TODOTXT_VERBOSE=0 $_todo_sh command listaddons 2>/dev/null)";;
            -*) completions="$COMMANDS $(eval TODOTXT_VERBOSE=0 $_todo_sh command listaddons 2>/dev/null) $OPTS";;
            *)  if [[ "$prev" =~ ^(addto|listfile|lf${_todo_file1_actions:+|${_todo_file1_actions}})$ ]]; then
                    completions=$(eval TODOTXT_VERBOSE=0 $_todo_sh command listfile 2>/dev/null)
                else
                    case "$cur" in
                        +*) completions=$(eval TODOTXT_VERBOSE=0 $_todo_sh command listproj 2>/dev/null)
                            COMPREPLY=( $( compgen -W "$completions" -- $cur ))
                            [ ${#COMPREPLY[@]} -gt 0 ] && return 0
                            # Fall back to projects extracted from done tasks.
                            completions=$(eval 'TODOTXT_VERBOSE=0 TODOTXT_SOURCEVAR=\$DONE_FILE' $_todo_sh command listproj 2>/dev/null)
                            ;;
                        @*) completions=$(eval TODOTXT_VERBOSE=0 $_todo_sh command listcon 2>/dev/null)
                            COMPREPLY=( $( compgen -W "$completions" -- $cur ))
                            [ ${#COMPREPLY[@]} -gt 0 ] && return 0
                            # Fall back to contexts extracted from done tasks.
                            completions=$(eval 'TODOTXT_VERBOSE=0 TODOTXT_SOURCEVAR=\$DONE_FILE' $_todo_sh command listcon 2>/dev/null)
                            ;;
                        *)  if [[ "$cur" =~ ^[0-9]+$ ]]; then
                                declare -a sedTransformations=(
                                    # Remove the (padded) task number; we prepend the
                                    # user-provided $cur instead.
                                    -e 's/^ *[0-9]\{1,\} //'
                                    # Remove the timestamp prepended by the -t option,
                                    # but keep any priority (as it's short and may
                                    # provide useful context).
                                    -e 's/^\((.) \)\{0,1\}[0-9]\{2,4\}-[0-9]\{2\}-[0-9]\{2\} /\1/'
                                    # Remove the done date and (if there) the timestamp.
                                    # Keep the "x" (as it's short and may provide useful
                                    # context)
                                    -e 's/^\([xX] \)\([0-9]\{2,4\}-[0-9]\{2\}-[0-9]\{2\} \)\{1,2\}/\1/'
                                    # Remove any trailing whitespace; the Bash
                                    # completion inserts a trailing space itself.
                                    -e 's/[[:space:]]*$//'
                                    # Finally, limit the output to a single line just as
                                    # a safety check of the ls action output.
                                    -e '1q'
                                )
                                local todo=$( \
                                    eval TODOTXT_VERBOSE=0 $_todo_sh '-@ -+ -p -x command ls "^ *${cur} "' 2>/dev/null | \
                                    sed "${sedTransformations[@]}" \
                                )
                                # Append task text as a shell comment. This
                                # completion can be a safety check before a
                                # destructive todo.txt operation.
                                [ "$todo" ] && COMPREPLY[0]="$cur # $todo"
                                return 0
                            else
                                return 0
                            fi
                            ;;
                    esac
                fi
                ;;
        esac
    fi

    COMPREPLY=( $( compgen -W "$completions" -- $cur ))
    return 0
}
complete -F _todo todo.sh

# If you define an alias (e.g. "t") to todo.sh, you need to explicitly enable
# completion for it, too:
#complete -F _todo t
# It is recommended to put this line next to your alias definition in your
# ~/.bashrc (or wherever else you're defining your alias). If you simply
# uncomment it here, you will need to redo this on every todo.txt update!

# If you have renamed the todo.sh executable, or if it is not accessible through
# PATH, you need to add and use a wrapper completion function, like this:
#_todoElsewhere()
#{
#    local _todo_sh='/path/to/todo2.sh'
#    _todo "$@"
#}
#complete -F _todoElsewhere /path/to/todo2.sh

# If you use aliases to use different configuration(s), you need to add and use
# a wrapper completion function for each configuration if you want to complete
# from the actual configured task locations:
#alias todo2='todo.sh -d "$HOME/todo2.cfg"'
#_todo2()
#{
#    local _todo_sh='todo.sh -d "$HOME/todo2.cfg"'
#    _todo "$@"
#}
#complete -F _todo2 todo2
