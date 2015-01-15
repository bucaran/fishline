# NAME
#   spec.functions - retrieve functions in the global scope that match ^key
#
# SYNOPSIS
#   spec.functions [OPTIONS] <key>
#
# OPTIONS
#   See grep(1)
#
# EXAMPLES
#   spec.functions "describe_"
#   spec.functions -q "before_"
#/
function spec.functions -a key
  set -l key $argv[-1]
  set -e argv[-1]
  if [ -n "$key" ]
    # Skip empty strings to avoid fetching all global functions.
    functions -n | grep $argv \^"$key"
  end
end
