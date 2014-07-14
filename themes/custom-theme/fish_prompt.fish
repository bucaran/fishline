
# Testing the current version of the theme against the current custom
# Print a warning if the file has been changed.
# Assuming classic installation, oh-my-fish is a git repo
set -l oh_my_fish_path (status -f|sed 's-/custom.*\?$--')
set -lx GIT_DIR "$oh_my_fish_path/.git"
set -lx GIT_WORK_TREE "$oh_my_fish_path"

set -l theme_path $oh_my_fish_path/themes/$fish_custom_theme/fish_prompt.fish
set -l custom_path $oh_my_fish_path/custom/themes/$fish_custom_theme/fish_prompt.fish

set -l theme_version __customtheme_theme_prompt_version_$fish_custom_theme
set -l custom_version __customtheme_custom_prompt_version_$fish_custom_theme

if git status > /dev/null ^&1
  if test -f "$theme_path" ; and test -f "$custom_path"
	 echo $custom_path
    set -l current_theme_version (git log -n 1 -- $theme_path | grep commit)
    set -l current_custom_version (command ls -lon --time-style +%s "$custom_path"|\
    sed 's- /.*$--;s/^\([^0-9]*[0-9]\+\)\{3\} //')

    if not set -q $theme_version 
  	   or not set -q $custom_version

	   set -U $theme_version $current_theme_version
	   set -U $custom_version $current_custom_version
    else if not test $$theme_version = $current_theme_version
	   if test $$custom_version = $current_custom_version
  		  set_color red
	  	  echo -e "The theme '$fish_custom_theme' has been changed.\nAn update to your custom file is necessary."
  		  set_color normal
	   else
		  set -U $theme_version $current_theme_version
  		  set -U $custom_version $current_custom_version
	   end
    end
  end
end

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
