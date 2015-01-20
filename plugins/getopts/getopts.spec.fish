import plugins/getopts
import plugins/fish-spec

function describe_getotps -d "fish getopts"
  function it_returns_1_if_empty
    getopts
    expect $status --to-equal 1
  end

  function it_reads_a_single_short_option
    set optstr "a"
    set option (getopts "$optstr" -a)
    getopts
    expect "$option" --to-equal a
  end

  function it_reads_multiple_short_options
    set optstr "a b c"
    set args -ab -cb
    set option (getopts "$optstr" $args)
    expect "$option" --to-equal a
      or return

    set option (getopts "$optstr" $args)
    expect "$option" --to-equal b
      or return

    set option (getopts "$optstr" $args)
    expect "$option" --to-equal c
      or return

    set option (getopts "$optstr" $args)
    getopts
    expect "$option" --to-equal b
  end

  function it_reads_a_short_style_option
    set optstr "a:an-option"
    set option (getopts "$optstr" -a)
    getopts
    expect "$option" --to-equal a
  end

  function it_reads_a_long_style_option
    set optstr "a:an-option"
    set option (getopts "$optstr" --an-option)
    getopts
    expect "$option" --to-equal a
  end

  function it_reads_an_option_with_argument
    set optstr "a:an-option:"
    set option (getopts "$optstr" --an-option the_value)
    expect "$option[1]" --to-equal a
    and begin
      getopts
      expect "$option[2]" --to-equal the_value
    end
  end

  function it_reads_an_option_with_argument_joined
    set optstr "a:an-option:"
    set option (getopts "$optstr" -athe_value)
    expect "$option[1]" --to-equal a
    and begin
      getopts
      expect "$option[2]" --to-equal the_value
    end
  end
  #
  function it_reads_a_single_short_option_with_optional_argument
    set optstr "a:^"
    set option (getopts "$optstr" -athe_value)
    expect "$option[1]" --to-equal a
    and begin
      getopts
      expect "$option[2]" --to-equal the_value
    end
  end

  function it_reads_a_single_short_option_with_optional_argument_missing
    set optstr "a:^"
    set option (getopts "$optstr" -a)
    expect "$option[1]" --to-equal a
    and begin
      getopts
      expect "$option[2]" --to-equal ""
    end
  end

  function it_reads_a_long_option_with_optional_argument
    set optstr "a:an-option:^"
    set option (getopts "$optstr" --an-option=the_value)
    expect "$option[1]" --to-equal a
    and begin
      getopts
      expect "$option[2]" --to-equal the_value
    end
  end

  function it_reads_a_long_option_with_optional_argument_missing
    set optstr "a:an-option:^"
    set option (getopts "$optstr" --an-option 1 2 3)
    expect "$option[1]" --to-equal a
    and begin
      expect "$option[2]" --to-equal ""
      set option (getopts "$optstr" --an-option 1 2 3)
      expect "$option" --to-equal "1 2 3"
    end
  end

  function it_reads_options_with_all_optional_args_missing
    set optstr "m:^ p:^ q:^"
    set option (getopts "$optstr" -m -p -q)
    expect "$option[1]" --to-equal m
      and expect "$option[2]" --to-equal ""
      or return

    set option (getopts "$optstr" -m -p -q)
    expect "$option[1]" --to-equal p
      and expect "$option[2]" --to-equal ""
      or return

    set option (getopts "$optstr" -m -p -q)
    expect "$option[1]" --to-equal q
    and begin
      getopts
      expect "$option[2]" --to-equal ""
    end
  end

  function it_reads_a_long_style_only_option_with_argument
    set optstr "long-option:"
    set option (getopts "$optstr" -a --long-option the_value)
    expect "$option[1]" --to-equal a
      or return
    set option (getopts "$optstr" -a --long-option the_value)
    expect "$option[1]" --to-equal long-option
    and begin
      getopts
      expect "$option[2]" --to-equal the_value
    end
  end

  function it_reads_multiple_short_style_options_with_argument
    set optstr "x:xxx: y:yyy: z:zzz:"
    set option (getopts "$optstr" -x Xx -y Yy -z Zz)
    expect "$option[1]" --to-equal x
      and expect "$option[2]" --to-equal Xx
    or return

    set option (getopts "$optstr" -x Xx -y Yy -z Zz)
    expect "$option[1]" --to-equal y
      and expect "$option[2]" --to-equal Yy
    or return

    set option (getopts "$optstr" -x Xx -y Yy -z Zz)
    expect "$option[1]" --to-equal z
    and begin
      getopts
      expect "$option[2]" --to-equal Zz
    end
  end

  function it_reads_multiple_mixed_style_options_with_argument
    set optstr "x:xxx: y:yyy: z:zzz:"
    set option (getopts "$optstr" -x Xx --yyy Yy --zzz Zz)
    expect "$option[1]" --to-equal x
      and expect "$option[2]" --to-equal Xx
    or return

    set option (getopts "$optstr" -x Xx --yyy Yy --zzz Zz)
    expect "$option[1]" --to-equal y
      and expect "$option[2]" --to-equal Yy
    or return

    set option (getopts "$optstr" -x Xx --yyy Yy --zzz Zz)
    expect "$option[1]" --to-equal z
    and begin
      getopts
      expect "$option[2]" --to-equal Zz
    end
  end

  function it_reads_multiple_options_with_optional_argument_mixed
    set optstr "x:xxx: y:yyy:^ z:zzz:^"
    set option (getopts "$optstr" --xxx 1985 -y6 -z)
    expect "$option[1]" --to-equal x
      and expect "$option[2]" --to-equal 1985
    or return

    set option (getopts "$optstr" --xxx 1985 -y6 -z)
    expect "$option[1]" --to-equal y
      and expect "$option[2]" --to-equal 6
    or return

    set option (getopts "$optstr" --xxx 1985 -y6 -z)
    expect "$option[1]" --to-equal z
    and begin
      getopts
      expect "$option[2]" --to-equal ""
    end
  end

  function it_reads_a_complex_optstr
    set optstr "m:member v:active n:name: l:last-name: a:age:^ x:sex:^"
    while set option (getopts "$optstr" -n Jorge -l Bucaran -mva29 --sex=Male)
      switch $option[1]
        case n
          set result $result "Name: $option[2]"
        case l
          set result $result "Last Name: $option[2]"
        case m
          set result $result "Member: YES"
        case v
          set result $result "Active: YES"
        case a
          set result $result "Age: $option[2]"
        case x
          set result $result "Sex: $option[2]"
      end
    end
    expect $result --to-equal "Name: Jorge Last Name: Bucaran Member: YES Active: YES Age: 29 Sex: Male"
  end
end

spec.run $argv
