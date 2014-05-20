#!/bin/fish




#!/usr/bin/env fish


# Takes color as first argument, and text to print as other arguments.
function colored
    set_color $argv[1]
    set -e argv[1]
    echo $argv
    set_color normal
end


# Outline of argument parsing found from Nicolas Vanhoren @ 
# http://butterflyprogramming.neoname.eu/programming-with-fish-shell/
function help_exit
    echo "Usage:  [options] [argument]"
    echo "Options:"
    echo \t '--remove | -r: Move current config.fish to backup (config.orig) and substitute template config file'
    echo \t "--modify | -m: Append template configuration onto end of current config.fish"
    echo "Argument:"
    echo \t "<path/to/install/directory>: By default, Oh My Fish will install in ~/.oh-my-fish."
    echo \t\t "If you wish to install in a different location, specify the path as an argument."
    exit 1
end

set args (getopt -s sh -l modify,remove rm $argv); or help_exit
set args (fish -c "for el in $args; echo \$el; end")

set i 1
while true
    switch $args[$i]
        case "-r" "--remove"
            set action "r"
        case "-m" "--modify"
            set action "m"
        case "--"
            break
    end
    set i (math "$i + 1")
end

if math "$i <" (count $args) > /dev/null
    set pargs $args[(math "$i + 1")..-1]
end

echo "action: $action"
echo "positional arguments:" $pargs
echo "parg[1]: $pargs[1]"

# tests for presence of install_dir positional argument. 
# if none is found set install_dir to standard install location
if set -q pargs[1]
    colored yellow "Setting installation directory to $pargs[1]."
    set install_dir $pargs[1]
else
    # Set install_dir to standard location 
    colored yellow "Installation directory not specified. Installing in standard location: ~/.oh-my-fish/"
    set install_dir ~/.oh-my-fish
end

# Test if the installation directory is empty. Replaces test for ~/.oh-my-fish/
if test -d $install_dir
    if test (find $install_dir -maxdepth 0 -type d -empty | wc -l) -ne 1
        colored yellow -n You already have Oh My Fish installed or are trying to install to a non-empty folder.
        echo " You'll need to remove the contents of $install_dir if you want to install Oh My Fish there."
        exit 1
    end
end

colored blue Cloning Oh My Fish...
type git >/dev/null
# Note: Substituted this to test with templated config.fish
and git clone https://github.com/gabeos/oh-my-fish.git
#and git clone https://github.com/bpinto/oh-my-fish.git $install_dir
or begin
    echo "git not installed or couldn't create directory at $install_dir"
    exit 1
end

colored blue Looking for an existing fish config...
if test -e ~/.config/fish/config.fish
  colored yellow "Found ~/.config/fish/config.fish."

  if not set -q action
    read -l -p 'echo "Modify (append needed lines), replace (with backup)? [M/r]: "' action
  end

  set modify_options 'm' 'M'
  if contains $modify_options $action
    colored green " Using the Oh My Fish template file and adding it to the end of ~/.config/fish/config.fish"

    echo -e "\n### Oh My Fish configuration\n" >> ~/.config/fish/config.fish
    cat $install_dir/templates/config.fish | sed 's!<oh-my-fish-installation-directory>!'"$install_dir"'!' >> ~/.config/fish/config.fish
  else
    colored green " Backing up to ~/.config/fish/config.orig"
    mv ~/.config/fish/config.{fish,orig}

    colored green "Using the Oh My Fish template file to replace ~/.config/fish/config.fish"
    cat $install_dir/templates/config.fish | sed 's!<oh-my-fish-installation-directory>!'"$install_dir"'!' > ~/.config/fish/config.fish
  end
else
  colored green "Using the Oh My Fish template file to create ~/.config/fish/config.fish"
  cat $install_dir/templates/config.fish | sed 's!<oh-my-fish-installation-directory>!'"$install_dir"'!' > ~/.config/fish/config.fish
end


colored blue "Using the Oh My Fish template file and adding it to ~/.config/fish/config.fish"

colored green \
'          _
         | |
     ___ | |__    _ __ ___  _   _
    / _ \|  _ \  |  _ ` _ \| | | |
   | (_) | | | | | | | | | | |_| |
    \___/|_| |_| |_| |_| |_|\__, |
                             __/ |
                            |___/
'

# Print nice fish logo with colors.
echo '                   '(set_color F00)'___
    ___======____='(set_color FF7F00)'-'(set_color FF0)'-'(set_color FF7F00)'-='(set_color F00)')
  /T            \_'(set_color FF0)'--='(set_color FF7F00)'=='(set_color F00)')
  [ \ '(set_color FF7F00)'('(set_color FF0)'0'(set_color FF7F00)')   '(set_color F00)'\~    \_'(set_color FF0)'-='(set_color FF7F00)'='(set_color F00)')
   \      / )J'(set_color FF7F00)'~~    \\'(set_color FF0)'-='(set_color F00)')
    \\\\___/  )JJ'(set_color FF7F00)'~'(set_color FF0)'~~   '(set_color F00)'\)
     \_____/JJJ'(set_color FF7F00)'~~'(set_color FF0)'~~    '(set_color F00)'\\
     '(set_color FF7F00)'/ '(set_color FF0)'\  '(set_color FF0)', \\'(set_color F00)'J'(set_color FF7F00)'~~~'(set_color FF0)'~~     '(set_color FF7F00)'\\
    (-'(set_color FF0)'\)'(set_color F00)'\='(set_color FF7F00)'|'(set_color FF0)'\\\\\\'(set_color FF7F00)'~~'(set_color FF0)'~~       '(set_color FF7F00)'L_'(set_color FF0)'_
    '(set_color FF7F00)'('(set_color F00)'\\'(set_color FF7F00)'\\)  ('(set_color FF0)'\\'(set_color FF7F00)'\\\)'(set_color F00)'_           '(set_color FF0)'\=='(set_color FF7F00)'__
     '(set_color F00)'\V    '(set_color FF7F00)'\\\\'(set_color F00)'\) =='(set_color FF7F00)'=_____   '(set_color FF0)'\\\\\\\\'(set_color FF7F00)'\\\\
            '(set_color F00)'\V)     \_) '(set_color FF7F00)'\\\\'(set_color FF0)'\\\\JJ\\'(set_color FF7F00)'J\)
                        '(set_color F00)'/'(set_color FF7F00)'J'(set_color FF0)'\\'(set_color FF7F00)'J'(set_color F00)'T\\'(set_color FF7F00)'JJJ'(set_color F00)'J)
                        (J'(set_color FF7F00)'JJ'(set_color F00)'| \UUU)
                         (UU)'(set_color normal)

echo
echo
colored green ' ....is now installed.'

# Run shell after installation.
fish
