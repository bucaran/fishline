# SYNOPSIS
#   basename <string> [suffix]
#   basename [-s suffix] <string> [string...]
#
# OVERVIEW
#   Consistent basename across Linux and OS X.

function basename -d "Return filename or directory portion of pathname"
  if set -q argv[1]
    set -l ext ""
    switch $argv[1]
      case -s
        if test (count $argv) -gt 2
          set ext $argv[2]
          set argv $argv[3..-1]
        else
          echo "basename: Invalid number of arguments"
          return 1
        end
    end
    for path in $argv
      command basename "$path" "$ext"
    end
  end
end
