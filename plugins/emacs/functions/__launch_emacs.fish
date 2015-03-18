function __launch_emacs
  set -l x (emacsclient --alternate-editor '' --eval '(x-display-list)' 2>/dev/null)

  test -z $x; or test $x = nil
  and emacsclient $argv --alternate-editor '' --create-frame
  or emacsclient $argv --alternate-editor ''
end
