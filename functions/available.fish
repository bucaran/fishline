# SYNOPSIS
#   available [name]
#
# OVERVIEW
#   Check if a program is available.

function available -a program -d "Check if a command can be executed"
  type "$program" ^/dev/null >&2
end
