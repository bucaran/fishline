# Print a message with msg and wait for y/n input. Return true on y\*.
# @params See msg.fish
function msg.ask
  msg $argv
  head -n 1 | read answer
  switch $answer
    case y\* Y\*
      return 0
    case \*
      return 1
  end
end
