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
  end

  function it_adds_a_dot_for_a_successful_expectation
    set -l suite "
        import plugins/fish-spec

        function describe_suite
          function it_is_executed
            expect 'success' --to-equal 'success'
          end
        end

        spec.run
      "

    set -l output (run_nested_suite $suite)
    set -l dot    (echo -ne (set_color green).(set_color white))

    expect (echo $output) --to-equal $dot
  end

  function it_adds_a_dot_for_each_successful_expectation
    set -l suite "
        import plugins/fish-spec

        function describe_suite
          function it_is_executed
            expect 'success' --to-equal 'success'
            expect 'success' --to-equal 'success'
          end
        end

        spec.run
      "

    set -l output (run_nested_suite $suite)
    set -l dot    (echo -ne (set_color green).(set_color white))

    expect (echo $output) --to-equal $dot$dot
  end
end

function run_nested_suite -a suite
  set -g original_function_names (functions -n)

  # Backup original suite functions
  for function_name in (functions -n | grep -E "it_|describe_")
    functions -c $function_name "backup.$function_name"
    functions -e $function_name
  end

  # Run nested suite
  eval $suite

  # Restore original suite functions
  for function_name in (functions -n | grep -E "backup.")
    functions -c $function_name (echo $function_name | sed -e 's/backup.//g')
    functions -e $function_name
  end

  # Remove functions created by the nested suite
  set function_names (functions -n)
  list.erase $original_function_names --from function_names
  for function_name in $function_names
    functions -e $function_name
  end
end

spec.run $argv
