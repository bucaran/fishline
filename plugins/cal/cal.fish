# NAME
#   cal - builtin cal thin wrapper for OS X
#
# USAGE
#   cal --color
#     Highlight the current day in cal output.
#
#   See `man cal` to learn more about cal builtin.
#
# BUGS
#   Hightlights all days matching the current date in year view.
#
# AUTHORS
#   Jorge Bucaran <jbucaran@me.com>
#/
function cal
  set -l color none
  if set -l index (contains -i -- --color $argv)
    # Delete our internal use-only --color option from arguments.
    set -e argv[$index]
    set color always
  end
  set -l today (date +%e | sed "s/ //g")

  # Use command cal to run the original cal command and not our wrapper.
  command cal $argv | env GREP_COLOR='1;93' \
    grep -E --color=$color "$month\b$today\b|\$"
end
