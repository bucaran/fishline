function za
    if [ -z $argv[1] ]
        set za_mark 1
    else
        set za_mark $argv[1]
    end

    set za_dir $PWD

    # When in home, do nothing
    [ $za_dir = $HOME ]; and return    

    while [ $za_mark -gt 0 -a $za_dir != $HOME ]
        set za_dir (dirname $za_dir)
        set za_mark (math $za_mark - 1)
    end

    cd $za_dir
end
