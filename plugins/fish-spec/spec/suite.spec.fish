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

  function it_runs_all_describe_blocks
    set -l suite "
        import plugins/fish-spec

        function describe_blank_suite
          echo 'first describe'
        end

        function describe_another_blank_suite
          echo 'second describe'
        end

        spec.run
      "

    expect (run_nested_suite $suite) --to-contain 'first describe' 'second describe'
    functions -e 'describe_blank_suite'
  end

  function it_runs_all_it_blocks
    set -l suite "
        import plugins/fish-spec

        function describe_suite
          function it_is_executed
            echo 'first test'
          end

          function it_is_also_executed
            echo 'second test'
          end
        end

        spec.run
      "

    expect (run_nested_suite $suite) --to-contain 'first test' 'second test'
    functions -e 'describe_suite'
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
