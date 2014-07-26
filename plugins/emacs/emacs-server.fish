function emacs-server
  emacs-server-kill
  emacs --daemon
end

function ema
  emacsclient --nw $argvs # --nw is necessary or you may cannot use input method in tty
end
