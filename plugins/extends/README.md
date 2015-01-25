## Extends plugin

This is a plugin that enable the possibility of adding “commands” to programs / functions.

Therefor its name **extends**, allowing you to extend programs.

## Extends example
Asume the following *git plugin* making use of the **extends** plugin:

```
function git --description 'Extends git command'
    _extends $argv
end

function _git-hi --description 'Shows version and hi'
    set -l git_version (command git --version)
    echo "Hi from $git_version! Feeling adventurous? Try `git help` ."
end

function _git-help --description ''
    _extends-help '--help'
end
```

This will **extends** the git programm and add a **hi** command to it allowing you to run the **git hi** command.
```
$git hi
Hi from git version 1.9.3! Feeling adventurous? Try `git help`.
```

Additionally you can implement the **git-help** function in your plugin and just call the **_extends-help** with a single argument.

The argument **must** be the invoke command for obtaining help on the original program you are extending (normally it will be either **help** or **--help**).
This will output the original help of the program plus all the funtions that your plugin defines in the format _pluginName-command (for instance: _git-hi in our example) and excluding _pluginName-help .

```
git help                                                                        
usage: git [--version] [--help] [-c name=value]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p|--paginate|--no-pager] [--no-replace-objects] [--bare]
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
           <command> [<args>]

The most commonly used git commands are:
   add        Add file contents to the index
   bisect     Find by binary search the change that introduced a bug
   branch     List, create, or delete branches
   checkout   Checkout a branch or paths to the working tree
   clone      Clone a repository into a new directory
   commit     Record changes to the repository
   diff       Show changes between commits, commit and working tree, etc
   fetch      Download objects and refs from another repository
   grep       Print lines matching a pattern
   init       Create an empty Git repository or reinitialize an existing one
   log        Show commit logs
   merge      Join two or more development histories together
   mv         Move or rename a file, a directory, or a symlink
   pull       Fetch from and integrate with another repository or a local branch
   push       Update remote refs along with associated objects
   rebase     Forward-port local commits to the updated upstream head
   reset      Reset current HEAD to the specified state
   rm         Remove files from the working tree and from the index
   show       Show various types of objects
   status     Show the working tree status
   tag        Create, list, delete or verify a tag object signed with GPG

'git help -a' and 'git help -g' lists available subcommands and some
concept guides. See 'git help <command>' or 'git help <concept>'
to read about a specific subcommand or concept.


    Added automatically from the _extends plugin (_git-):

        ● hi
```

## Author
[Josemi Liébana](http://josemi-liebana.com) [office@josemi-liebana.com](mailto:office@josemi-liebana.com)
