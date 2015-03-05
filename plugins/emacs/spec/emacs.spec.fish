set spec_path (dirname (status --current-filename))
set plugins_path (cd $spec_path; and cd ../..; and pwd)
set load_file $plugins_path/emacs/emacs.load

import plugins/fish-spec

function describe_emacs

  function it_sets_editor_on_load    
    set -e EDITOR
    set emacs '/bin/emacs'
    set emacs_version 25

    source $load_file

    expect $EDITOR --to-equal 'emacs'
  end

  function it_does_not_set_editor_when_it_is_already_set
    set emacs '/bin/emacs'
    set emacs_version 25
    
    set EDITOR 'vim'
    
    source $load_file

    expect $EDITOR --to-equal 'vim'
  end

  function it_does_not_set_editor_when_emacs_is_not_found
    set -e EDITOR

    set emacs ''
    
    source $load_file

    expect "$EDITOR" --to-equal ''
  end

  function it_does_not_set_editor_when_emacs_version_is_lower_than_23
    set -e EDITOR
    set emacs '/bin/emacs'
    set emacs_version 22
    
    source $load_file

    expect "$EDITOR" --to-equal ''
  end

  function it_does_not_add_functions_when_emacs_is_not_found
    set -e EDITOR

    set emacs ''

    expect (functions) --to-not-contain-all $emacs_functions

    source $load_file

    expect (functions) --to-not-contain-all $emacs_functions
  end

  function it_does_not_add_functions_when_emacs_version_is_lower_than_23
    set -e EDITOR
    set emacs '/bin/emacs'
    set emacs_version 22

    expect (functions) --to-not-contain-all $emacs_functions

    source $load_file

    expect (functions) --to-not-contain-all $emacs_functions
  end

  function it_adds_functions_to_fish_function_path
    set -e EDITOR
    set emacs '/bin/emacs'
    set emacs_version 25
    set emacs_functions e ecd eeval efile eframe ek emacs emasc emcas

    expect (functions) --to-not-contain-all $emacs_functions

    source $load_file

    expect (functions) --to-contain-all $emacs_functions
  end
end

spec.run $argv
