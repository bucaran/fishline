
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s -unormal --ignore-submodules=dirty ^/dev/null)
end

function _git_path
  echo (basename (git rev-parse --show-toplevel))/(git rev-parse --show-prefix) 
end

function fish_right_prompt
  set -l cyan (set_color cyan)
  set -l red (set_color red)
  set -l normal (set_color normal)
  set -l yellow (set_color yellow)
  set -l green (set_color green)
  set -l pink (set_color ff99ff)

  # Show git branch and dirty state
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)
    set -l dirty
    if [ (_is_git_dirty) ]
      set dirty "$red⌛ "
    end

    echo -n -s $yellow (_git_path) ' ' $git_branch $dirty
  else
    echo -n -s $yellow (prompt_pwd)
  end

  # Show hostname
  echo -n -s ' ' $green (hostname|cut -d . -f 1)
  echo -n ' '
  # Show jobs
  if builtin jobs | wc -l  | grep -Eqv '\b0\b'
    echo -n -s $cyan "[⚙]"
  end
  # Show date
  echo -n -s $pink '[' $dark_pink (date +%H:%M:%S) $pink ']' $normal
end
