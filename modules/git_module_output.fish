function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function git_module_output
  if [ (_git_branch_name) ]
    set -g git_branch (_git_branch_name)

    if [ (_is_git_dirty) ]
      if set -q GIT_MODULE_DIRTY
        set -g git_dirty $GIT_MODULE_DIRTY
      else
        set -g git_dirty "✗"
      end
    end

    if set -q GIT_MODULE_OUTPUT
      module_output $GIT_MODULE_OUTPUT
    end
  end

  set -e git_branch
  set -e git_dirty
end
