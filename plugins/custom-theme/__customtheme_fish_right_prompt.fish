function __customtheme_fish_right_prompt
  set -l retval 0

  # Testing the current version of the theme against the current custom
  # Print a warning if the file has been changed.
  # Assuming classic installation, oh-my-fish is a git repo
  set -lx GIT_DIR "$__customtheme_oh_my_fish_path/.git"
  set -lx GIT_WORK_TREE "$__customtheme_oh_my_fish_path"

  set -l theme_path $__customtheme_oh_my_fish_path/themes/$fish_custom_theme/fish_right_prompt.fish
  set -l custom_path $__customtheme_oh_my_fish_path/custom/themes/$fish_custom_theme/fish_right_prompt.fish

  set -l theme_version __customtheme_theme_right_prompt_version_$fish_custom_theme
  set -l custom_version __customtheme_custom_right_prompt_version_$fish_custom_theme

  if set -q __customtheme_git_check_ok
    if test -f "$theme_path" ; and test -f "$custom_path"
      set -l current_theme_version (command git log -n 1 -- "$theme_path" | command grep commit)

      if not set -q $theme_version 
        set -U $theme_version $current_theme_version

    # The theme has been changed !
      else if not test $$theme_version = $current_theme_version
        set -l current_custom_version (command ls -lon --time-style +%s "$custom_path"|\
        command sed 's- /.*$--;s/^\([^0-9]*[0-9]\+\)\{3\} //')
        if not set -q $custom_version
          set -U $custom_version $current_custom_version
        else if test $$custom_version = $current_custom_version
          set retval 1
        else
          set -U $theme_version $current_theme_version
          set -e $custom_version
        end
      end
    end
  end

  return $retval
end
