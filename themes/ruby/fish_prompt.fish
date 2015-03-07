function _git_branch_name
  echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (git status -s --ignore-submodules=dirty ^/dev/null)
end

function _rb_prompt
  echo (rvm version | awk '{print $1}')
end

function fish_prompt
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l normal (set_color normal)

  set -l arrow "$red➜ $normal"
  set -l cwd $cyan(prompt_pwd)

  set -l ruby_version $yellow(_rb_prompt)
  set -l ruby_version "$ruby_version$normal in "


  if [ (_git_branch_name) ]
  set -l git_branch $red(_git_branch_name)
  set git_info "$blue on $git_branch$blue"

  if [ (_is_git_dirty) ]
    set -l dirty "$yellow ✗"
    set git_info "$git_info$dirty"
  end
  end

  echo -s $ruby_version $cwd $git_info $normal \n $arrow " "
end
