# name: Fishline
# function _update_fishline

function __grab_fishline
  set -l fpath $fish_path/themes/fishline/fishline
  curl -sLo $fpath.zip "https://github.com/orax/fishline/archive/master.zip"
  rmdir $fpath
  unzip -q $fpath.zip
  mv "fishline-master" $fish_path
end

if not test -f $fish_path/themes/fishline/fishline/fishline.fish
  __grab_fishline
end
set FLINE_PATH $fish_path/themes/fishline/fishline/
set FLINE_PROMPT STATUS JOBS PWD GIT WRITE N ROOT
source $FLINE_PATH/themes/default.fish

function fish_prompt

  fishline $status

end
