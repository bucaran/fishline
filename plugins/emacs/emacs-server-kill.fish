function emacs-server-kill
  emacsclient -e "(kill-emacs)"
  echo "emacs server killed"
end
