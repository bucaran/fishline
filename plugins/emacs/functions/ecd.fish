function ecd
  set -l cmd '(let ((buf-name (buffer-file-name (window-buffer))))
             (if buf-name (file-name-directory buf-name)))'
  set -l dir (__launch_emacs --eval $cmd | tr -d '\"')

  test -n $dir
  and echo $dir
  or echo 'cannot deduce current buffer filename.' >/dev/stderr; return 1;
end
