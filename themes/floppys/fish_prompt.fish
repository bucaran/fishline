# name: floppys

function fish_prompt
  set -l last_status $status
  set -l yellow (set_color ffff33)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l cyan (set_color cyan)
  set -l normal (set_color normal)
  set -l dark_green (set_color 006600)

  set -l cwd $cyan(basename (prompt_pwd))
  
  # Prompt symbol
  set -l prompt
  if [ (whoami) = "root" ]
    set prompt "⚡ "
  else
    set prompt '$'
  end

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
    echo -n -s (set_color -b cyan black) '[' (basename "$VIRTUAL_ENV") ']' $normal ' '
  end

  # Did last command succeed
  if test $last_status -ne 0
    set ret_status $red 
  else
    set ret_status $yellow
  end

  # Show Username if meaningful
  set -l user_status
  if [ "$SSH_CLIENT" ]
    set user_status $blue (whoami) $yellow @ $blue (hostname|cut -d . -f 1) $yellow ':'
  else if [ "$SUDO_USER" -o (whoami) != "$default_user" ]
    set user_status $blue (whoami) $yellow ':'
  end

  # Display everything with or without emoji-clock
  if echo $fish_plugins | grep -q emoji-clock
    echo -n -s $user_status $cwd (emoji-clock) " " $ret_status $prompt
  else
    echo -n -s $user_status $cwd $ret_status $prompt
  end

  # Reset state
  echo -n -s ' ' $normal
end
