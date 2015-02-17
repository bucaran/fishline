# Skip test suite in Linux. cal already highlights the current day there.
test (uname) != 'Darwin'
  and exit 0

import plugins/fish-spec
import plugins/cal

function describe_tiny -d "cal plugin"
  function it_generates_different_escape_sequences_from_cal
    # Process substitution is used in order to pipe cal output to diff
    # without using files. diff exits with 1 if differences are found.
    diff (cal | psub) (cal --color | psub) >/dev/null
    expect $status --to-equal 1
  end

  function it_defaults_to_builtin_if_--color_option_is_not_used_x
    diff (command cal | psub) (cal | psub) >/dev/null
    expect $status --to-equal 0
  end
end

spec.run $argv
