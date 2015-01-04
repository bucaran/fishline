# NAME
#      _prepend_tree - add a dependency tree to fish_function_path
#
# SYNOPSIS
#      _prepend_tree [-P --preview] <path> [<glob>..]
#
# DESCRIPTION
#      Search a path tree and prepend directories with fish files.
#      Use a glob list to include / exclude other file extensions.
#
# OPTIONS
#      [-p --preview]
#          Do not modify the path. Print directories that match the glob.
#
#      <path>
#          Required. Specify the path to search for glob patterns.
#
#      [<glob> [<operator> <glob>..]]
#          Glob pattern to match when traversing the path path.
#
# OPERATORS
#      [! -not glob]
#          Negates the following glob.
#
#      [glob1] [-o -or] [glob2] ...
#          Default. Must meet at least one listed criteria.
#
#      [glob1 ] -a -and [glob2]
#          Must meet *all* listed criteria.
#
# EXAMPLES
#      _prepend_tree $path
#          Match directories in $path containing `.fish` files.
#
#      _prepend_tree $path \*.fish \*.sh
#          Match directories in $path with either `.fish` OR `.sh` files.
#
#      _prepend_tree $path \*.fish -a ! _\*.\*
#          Match directories with `.fish` files that do not start with `_`.
#
# AUTHORS
#      Jorge Bucaran <jbucaran@me.com>
#
# SEE ALSO
#      .oh-my-fish/functions/_prepend_path.fish
#
# v.0.2.0
#/
function _prepend_tree -d "Add a dependency tree to the Fish path."
  # Match directories with .fish files always.
  set -l glob -name \*.fish
  set -l path $argv[1]
  contains -- $path -p --preview
    and set path $argv[2]
  # Parse glob options to create the main glob pattern.
  if [ (count $argv) -gt 2 ]
    set -l operator -o
    for option in $argv[3..-1]
      switch $option
        case ! -not
          set operator $operator !
        case -o -or
          set operator -o
        case -a -and
          set operator -a
        case "*"
          [ operator = ! ]
            and set glob $operator $glob
            or set glob $glob $operator
          set glob $glob -name $option
          set operator -o # Default
      end
    end
  end
  # Travese $path and prepend only directories with matches.
  for dir in $path $path/**/
    # Use head to retrieve at least the first match.
    [ -z (find $dir $glob -maxdepth 1 | head -1) ]
      and continue

    contains -- $argv[1] -p --preview
      and printf "%s\n" $dir
      or _prepend_path $directory fish_function_path
  end
end
