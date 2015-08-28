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
#   + Source {$OMF_PATH,$OMF_CONFIG}/events → fish-shell#845
#   + Source $OMF_CONFIG/init.fish
#
# ENV
#   OSTYPE        Operating system
#   BAK_PATH      Original $PATH preseved across Oh My Fish! reloads
#   OMF_PATH      Set in ~/.config/fish/config.fish
#   OMF_SKIP      List of packages to ignore
#   OMF_CONFIG    Oh My Fish! configuration directory
#   OMF_VERSION   Oh My Fish! version

set -g OMF_VERSION "1.0.0"
set -q BAK_PATH; and set PATH $BAK_PATH; or set -gx BAK_PATH $PATH
set -q OSTYPE; or set -g OSTYPE (uname)
set fish_function_path {$OMF_PATH,$OMF_CONFIG}/functions $fish_function_path

for type in plugin theme
  for pkg in {$OMF_PATH,$OMF_CONFIG}/$type/(cat $OMF_CONFIG/config/$type)
    if not test -d $pkg
      if test (dirname $pkg) = "$OMF_PATH/$type"
        omf.install --$type (basename $pkg | tr -d " ")
      end
    end
    autoload $pkg{,/completions}
    if test $type = "plugin"
      source $pkg/(basename $pkg).fish
      emit init_(basename $pkg) "$pkg"
    end
  end
end

for path in {$OMF_PATH,$OMF_CONFIG}/events.fish $OMF_CONFIG/init.fish
  source $path ^/dev/null
end
