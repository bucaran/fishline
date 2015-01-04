# NAME
#      import - load libraries, plugins, themes, etc.
#
# SYNOPSIS
#      import <path/library>[<path/library>..]
#
# DESCRIPTION
#      Use to handle plugin interdependencies. Import libraries, plugins,
#      themes, completions, etc. Prepends custom/<library> to the path to
#      allow users to customize / override specific functions.
#
# EXAMPLES
#      import plugins/dpaste themes/bobthefish
#      import plugins/{cask,brew,django}
#
# AUTHORS
#      Jorge Bucaran <jbucaran@me.com>
#
# SEE ALSO
#      functions/_prepend_path.fish
#      functions/_prepend_tree.fish
#
# v.0.1.0
#/
function import -d "Load libraries, plugins, themes, etc."
  # $fish_path and $fish_custom point to oh-my-fish home and the user
  # dotfiles folder respectively. Both globals are usually configured
  # in ~/.config/fish/config.fish
  set -l root $fish_path $fish_custom

  for library in $argv
    # Each path expands to create 2 × $root unique paths.
    set -l paths $root/$library $root/$library/completions
    set -l plugins     $paths[1..2]" fish_function_path"
    set -l completions $paths[3..4]" fish_complete_path"

    # Prepend plugins and completion paths to fish_function_path and
    # fish_complete_path respectively. The root paths are determined
    # via the global $fish_path and $fish_custom.
    for path in $plugins $completions
      eval "_prepend_path "$path
    end

    # Traverse the library tree and prepend directories with fish files.
    _prepend_tree $fish_path/$library

    # Source each library (plugin, theme,...) configuration load file.
    for path in $root/$library/(basename $library).load
      [ -e $path ]
        and eval ". "$path
    end
  end
end
