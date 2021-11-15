# [![todo.txt-cli](http://todotxt.org/images/todotxt_logo_2012.png)][website]

> A simple and extensible shell script for managing your todo.txt file.

![CI](https://github.com/todotxt/todo.txt-cli/workflows/CI/badge.svg)
[![GitHub issues](https://img.shields.io/github/issues/todotxt/todo.txt-cli.svg)](https://github.com/todotxt/todo.txt-cli/issues)
[![GitHub forks](https://img.shields.io/github/forks/todotxt/todo.txt-cli.svg)](https://github.com/todotxt/todo.txt-cli/network)
[![GitHub stars](https://img.shields.io/github/stars/todotxt/todo.txt-cli.svg)](https://github.com/todotxt/todo.txt-cli/stargazers)
[![GitHub license](https://img.shields.io/github/license/todotxt/todo.txt-cli.svg)](https://raw.githubusercontent.com/todotxt/todo.txt-cli/master/LICENSE)
[![Gitter](https://badges.gitter.im/join_chat.svg)](https://gitter.im/todotxt/todo.txt-cli)

![gif](./.github/example.gif)

*Read our [contributing guide][CONTRIBUTING] if you're looking to contribute (issues/PRs/etc).*


## Installation

### Download
Download the latest stable [release][release] for use on your desktop or server.

### OS X / macOS

```shell
brew install todo-txt

# For macOS on x86 CPU 
cp -n /usr/local/opt/todo-txt/todo.cfg ~/.todo.cfg

# For macOS on arm CPU
cp -n /opt/homebrew/opt/todo-txt/todo.cfg ~/.todo.cfg
```

**Note**: The `-n` flag for `cp` makes sure you do not overwrite an existing file.

### Linux

#### From command line

```shell
make
make install
make test
```

*NOTE:* Makefile defaults to several default paths for installed files. Adjust to your system:

- `INSTALL_DIR`: PATH for executables (default /usr/local/bin)
- `CONFIG_DIR`: PATH for todo.txt config
- `BASH_COMPLETION`: PATH for autocompletion scripts (default to /etc/bash_completion.d)

```shell
make install CONFIG_DIR=/etc INSTALL_DIR=/usr/bin BASH_COMPLETION=/usr/share/bash-completion/completions
```

#### Arch Linux (AUR)

https://aur.archlinux.org/packages/todotxt/


## Usage
```shell
todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
```

For example, to add a todo item, you can do:

```shell
todo.sh add "THING I NEED TO DO +project @context"
```

Read about all the possible commands in the [USAGE][USAGE] file.


## Release History

See [CHANGELOG.md][CHANGELOG]


## Support

- [Github Discussions](https://github.com/todotxt/todo.txt-cli/discussions)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/todotxt)
- [Twitter](https://twitter.com/todotxt)


## Code of Conduct

[Contributor Code of Conduct][CODE_OF_CONDUCT]. By participating in this project you agree to abide by its terms.

## Contributing

We welcome all contributions. First read our [Contributor Code of Conduct][CODE_OF_CONDUCT] and then get started [contributing][CONTRIBUTING].

## License

GNU General Public License v3.0 © [todo.txt org][github]



[release]: https://github.com/todotxt/todo.txt-cli/releases
[website]: http://todotxt.org/
[github]: https://github.com/todotxt
[USAGE]: ./USAGE.md
[CHANGELOG]: ./CHANGELOG.md
[CODE_OF_CONDUCT]: .github/CODE_OF_CONDUCT.md
[CONTRIBUTING]: .github/CONTRIBUTING.md
