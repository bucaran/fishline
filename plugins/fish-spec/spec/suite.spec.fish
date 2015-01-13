import plugins/fish-spec

function describe_suite_run -d 'Testing a suite run'
  function it_has_an_output_if_suite_is_blank
    set -l suite "
        import plugins/fish-spec

        function describe_blank_suite
        end

        spec.run
      "

    expect (run_nested_suite $suite) --to-equal 'No tests found.'
    functions -e 'describe_blank_suite'
  end
end

function run_nested_suite -a suite
  for function_name in (functions -n | grep -E "it_|describe_")
    functions -c $function_name "backup.$function_name"
    functions -e $function_name
  end

  eval $suite

  for function_name in (functions -n | grep -E "backup.")
    functions -c $function_name (echo $function_name | sed -e 's/backup.//g')
    functions -e $function_name
  end
end

spec.run $argv
