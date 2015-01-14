import plugins/bak
import plugins/fish-spec

function describe_bak -d 'bak plugin'
  function before_all
    set -g test_dir /tmp/bak_test
    mkdir -p $test_dir
    pushd
    cd $test_dir
    rm -rf $test_dir/*
  end

  function after_each
    rm -rf $test_dir/*
  end

  function after_all
    popd
  end

  function it_checks_bak_filename_pattern_is_followed \
    -d "checks `bak` filename pattern is followed"
    expect __is_bak '.ccnet.20140817_234302.bak' --to-be-true
    expect __is_bak 'file\ with\ spaces.20140817_234302.bak' --to-be-true
    expect __is_bak '.ccnet.bak' --to-be-false
  end

  function it_normalizes_file_name -d "normalizes the file name"
    expect (__bak_normalized '.ccnet.20140817_234302.bak') --to-equal '.ccnet'
    expect (__bak_normalized 'file with spaces.20140817_234302.bak') --to-equal 'file with spaces'
  end

  function it_moves_a_single_file -d "moves a single file"
    touch a
    mvbak a
    expect __is_bak (ls) --to-be-true
  end

  function it_moves_multiple_files -d "moves multiple files"
    touch a b
    mvbak a b

    for f in (ls)
      expect __is_bak $f --to-be-true
    end
  end

  function it_unmoves_a_single_file -d "unmoves a single file"
    touch a
    mvbak a
    unmvbak (ls)

    expect (ls) --to-equal a
  end

  function it_unmoves_multiple_files -d "unmoves multiple files"
    set files (seq 4)
    touch $files
    mvbak $files
    unmvbak (ls)

    expect (ls) --to-equal "$files"
  end

  function it_copies_a_single_file -d "copies a single file"
    touch a
    cpbak a

    expect (ls | sort) --to-equal (echo -e 'a' (__bak_name a) | sort)
  end

  function it_copies_multiple_files -d "copies multiple files"
    set files (seq 4)
    touch $files
    cpbak $files

    for f in $files
      set files_bak $files_bak (__bak_name $f)
    end

    expect (ls | sort) --to-contain $files $file_bak
  end

  function it_uncopies_a_single_file -d "uncopies a single file"
    touch a
    cpbak a
    rm a
    uncpbak (ls)

    expect (ls | sort) --to-equal (echo -e 'a' (__bak_name a) | sort)
  end

  function it_uncopies_multiple_files -d "uncopies multiple files"
    set files (seq 4)
    touch $files
    mvbak $files
    unmvbak (ls)

    expect (ls) --to-equal "$files"
  end

  function it_uncopies_a_directory -d "uncopies a directory"
    mkdir a
    cpbak a/
    rmdir a
    uncpbak (ls -p)

    expect (ls -p | sort) --to-equal (echo -e (__bak_name a)'/' 'a/')
  end
end

spec.run $argv
