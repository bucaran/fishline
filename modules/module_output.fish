function module_output
  set -l black   (set_color black)
  set -l blue    (set_color blue)
  set -l brown   (set_color brown)
  set -l cyan    (set_color cyan)
  set -l green   (set_color green)
  set -l magenta (set_color magenta)
  set -l normal  (set_color normal)
  set -l purple  (set_color purple)
  set -l red     (set_color red)
  set -l white   (set_color white)
  set -l yellow  (set_color yellow)

  set -l bold_black   (set_color -o black)
  set -l bold_blue    (set_color -o blue)
  set -l bold_brown   (set_color -o brown)
  set -l bold_cyan    (set_color -o cyan)
  set -l bold_green   (set_color -o green)
  set -l bold_magenta (set_color -o magenta)
  set -l bold_normal  (set_color -o normal)
  set -l bold_purple  (set_color -o purple)
  set -l bold_red     (set_color -o red)
  set -l bold_white   (set_color -o white)
  set -l bold_yellow  (set_color -o yellow)

  set -l space ' '

  eval echo -n -s $argv
end

