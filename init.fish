# SYNOPSIS
#   Initialize Oh My Fish!
#
# OVERVIEW
#   + Autoload Oh My Fish! packages, themes and config path
#   + For each <plugin> inside {$OMF_PATH,$OMF_CONFIG}
#     + Autoload <plugin> directory
#     + Source <plugin>.fish
#     + Emit init_<plugin> event
#
#   + Autoload {$OMF_PATH,$OMF_CONFIG}/functions
#   + Source {$OMF_PATH,$OMF_CONFIG}/events → fish-shell/fish-shell/issues/845
#   + Source $OMF_CONFIG/init.fish
#
# ENV
#   OSTYPE        Operating system.
#   BAK_PATH      Original $PATH preseved across Oh My Fish! reloads.
#   OMF_PATH      Set in ~/.config/fish/config.fish
#   OMF_SKIP    List of packages to ignore.
#   OMF_CONFIG    Same as OMF_PATH. ~/.dotfiles by default.
#   OMF_VERSION   Oh My Fish!! version

set -q BAK_PATH; and set PATH $BAK_PATH; or set -gx BAK_PATH $PATH
set -q OSTYPE; or set -g OSTYPE (uname)

# Save the head of function path and autoload core functions
set -l user_function_path $fish_function_path[1]
set fish_function_path[1] $OMF_PATH/lib

set -l theme  {$OMF_PATH,$OMF_CONFIG}/themes/(cat $OMF_CONFIG/theme)
set -l paths  $OMF_PATH/plugins/*
set -l config $OMF_CONFIG/plugins/*
set -l ignore $OMF_SKIP

for path in $paths
  set config $OMF_CONFIG/(basename $path) $config
end

for path in $OMF_PATH/lib $OMF_PATH/lib/git $paths $theme $config
  contains -- (basename $path) $ignore; and continue
  autoload $path $path/completions
  source $path/(basename $path).fish ^/dev/null
    and emit init_(basename $path) $path
end

autoload $OMF_CONFIG/functions
autoload $user_function_path

for path in {$OMF_PATH,$OMF_CONFIG}/events.fish $OMF_CONFIG/init.fish
  source $path ^/dev/null
end

set -g OMF_VERSION "1.0.0"
