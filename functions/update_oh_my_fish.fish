#!/usr/bin/env fish
#
# Update oh-my-fish through git-pull or latest zip.
#/

# Check git repo status.
function _is_git_touched
	echo -n (command git status --porcelain ^/dev/null | grep "^[ MADRC]")
end

# Log a color message.
#   log <color> <string>...
function log
  echo -e (set_color $argv[1])$argv[2..-1](set_color normal)
end

# Allow installers to specify the source repository.
if not set -q TRAVIS_REPO_SLUG
  set TRAVIS_REPO_SLUG bpinto/oh-my-fish
  set TRAVIS_BRANCH master
end

set -l msg_done "Oh-My-Fish update successful!"
set -l omf_temp_zip "/tmp/oh-my-fish-latest.zip"
set -l omf_temp_dir "/tmp/omf-latest"

cd $fish_path

# Either git pull or curl GET repository.

if [ -d .git ]

  if [ ( _is_git_touched ) ]

    echo "Error: Your local changes would be overwritten by update.
       Please commit your changes or stash them before updating.
       Update aborted."
    exit 1

  else

    log blue "Pull Oh-My-Fish from remote repository..."

    git checkout $TRAVIS_BRANCH
    git pull
    and echo $msg_done.

    or log red "Pull from remote repository failed."
    and exit 1

  end

else

  find . -maxdepth 1 -not -name 'custom' | xargs rm -rf ^/dev/null

  log blue "Downloading remote zip from Github..."

  if curl -Lo $omf_temp_zip "https://github.com/$TRAVIS_REPO_SLUG/archive/master.zip"

    unzip -uo $omf_temp_zip -d $omf_temp_dir >/dev/null
    cd $omf_temp_dir/oh-my-fish-master
    cp -R * $fish_path
      and log green "Oh-My-Fish succesfully downloaded and extracted to $fish_path"
    rm -rf $omf_temp_zip $omf_temp_dir

  else

    log red "Oh-My-Fish could not be downloaded."
    log white "Report an issue → github.com/bpinto/oh-my-fish/issues"
    exit 1

  end

end
