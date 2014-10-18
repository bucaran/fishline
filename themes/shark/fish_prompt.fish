# name: shark
# By: Shahin Azad <me@5hah.in>
function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  set_color -o red
  printf '┌['
  set_color yellow
  printf '%s' (whoami)
  set_color red
  printf '@'
  set_color yellow
  printf '%s' (hostname|cut -d . -f 1)
  set_color red
  printf ']['
  set_color yellow
  printf '%s' (prompt_pwd)
  set_color red
  printf ']'

  echo
  set_color red
  printf '└> '
  
  set_color normal
end	
