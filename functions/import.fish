# NAME
#      import - load libraries, plugins, themes, etc.
#
# SYNOPSIS
#      import <path/library>[<path/library>..]
#
# DESCRIPTION
#      Import libraries, plugins, themes, completions. Prepend existing
#      user custom/<library> directories to the path to allow users to
#      override specific functions in themes/plugins.
#
# NOTES
#      $fish_path and $fish_custom point to oh-my-fish home and the user
#      dotfiles folder respectively. Both globals are usually configured
#      in ~/.config/fish/config.fish
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
# v.0.2.0
#/
function import -d "Load libraries, plugins, themes, etc."
  for library in $argv
    # Prepend plugins, themes and completions. Also traverse
    # the library tree prepending directories with fish code.
    # This allows to create project trees  with fish code
    # organized in directories according to a plugin's API.
    _prepend_tree $fish_path/$library
    _prepend_path $fish_path/$library/completions -d fish_complete_path

    # Source each library (plugin, theme,...) configuration load file.
    for path in $root/$library/(basename $library).load
      if [ -e $path ]
        . $path
      end
    end
  end
end
