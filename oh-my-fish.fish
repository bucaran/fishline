# Set fish_custom to the path where your custom config files
# and plugins exist, or use the default custom instead.
if not set -q fish_custom
  set -g fish_custom $fish_path/custom
end

# Extract user defined functions from path and prepend later to
# avoid collisions with oh-my-fish internal functions and allow
# users to override/customize plugins, themes, etc.
set user_function_path $fish_function_path[1]
set -e fish_function_path[1]

# Add functions defined in oh-my-fish/functions to path.
if not contains $fish_path/functions/ $fish_function_path
  set fish_function_path $fish_path/functions/ $fish_function_path
end

# Add required plugins, completions and themes. Imported commands can be
# customized via the $fish_path/custom, including themes and completions.
# To customize a theme, create a directory under $fish_path/custom/themes
# with the same name as the theme. Use the same approach for plugins, etc.
import plugins/$fish_plugins themes/$fish_theme

# Source all files inside custom folder.
for config_file in $fish_custom/*.load
  . $config_file
end

# Prepend extracted user functions so they have the highest priority.
set fish_function_path $user_function_path $fish_function_path
