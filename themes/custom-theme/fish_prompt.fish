
set -l oh_my_fish_path (status -f|command sed 's-/custom.*\?$--')

set -l theme_path $oh_my_fish_path/themes/$fish_custom_theme/fish_prompt.fish
set -l custom_path $oh_my_fish_path/custom/themes/$fish_custom_theme/fish_prompt.fish

function __load_system_fish_prompt
  if test -f /etc/fish/functions/fish_prompt.fish
	 source /etc/fish/functions/fish_prompt.fish
  else if test -f /usr/share/fish/functions/fish_prompt.fish
  	 source /usr/share/fish/functions/fish_prompt.fish
  end
end

# Assuming that if COLORTERM isn't set we are in a tty
# In a tty fallback to system fish_prompt
if not set -q COLORTERM
  __load_system_fish_prompt
else if test -f "$custom_path"
  source $custom_path
else if test -f "$theme_path"
  source $theme_path
else
  __load_system_fish_prompt
end
