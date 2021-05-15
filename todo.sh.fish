# Completions for todo.sh cli tool:
# https://github.com/todotxt/todo.txt-cli
#
# To install, copy this file to:
# ~/.config/fish/completions/
#
# Implemented
#
# - [x] initial subcommands
# - [x] project completion for add*
#
# Todo
#
# - [ ] command options
# - [ ] aliases
#

# get all available sub command (contains aliases)
set all_args (todo.sh -h | sed -n -e '/  Actions\:/,/  Actions can/ p' | grep -v MORE | sed -e '1d;$d' | awk NF | string trim | cut -d' ' -f1)
# get only the first command alias
set args (string split ' ' $all_args | cut -d'|' -f1)

# get all args help in a lazy manner (fetch and memoize)
set help_args ""
function __fish_todosh_args_with_help
  if test $help_args = ""
    for arg in (string split ' ' $args);
      set help (todo.sh help $arg | sed -n -e '/      /,// p' | string trim | tr '\n' ' ')
        set help_args $help_args(printf '%s\t%s' $arg $help)\n
    end
  end
  echo $help_args | awk NF
end

# prevent files completion to todo.sh
complete -c todo.sh -f
# add subcommands and prevent further repetition
complete -c todo.sh -n "not __fish_seen_subcommand_from $args" -a "(__fish_todosh_args_with_help)"

# get projects
function __fish_todosh_plus
  if __fish_seen_subcommand_from add addm
    if test (commandline | string split "")[-1] = "+"
      return 0
    end
  end
  return 1
end
function __fish_todosh_projects
  todo.sh listproj
end

# add projects to all commands that add text
complete -c todo.sh -n "__fish_todosh_plus" -a "(__fish_todosh_projects)"
