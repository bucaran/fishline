#!/usr/bin/env fish
set -g fish_greeting

if test -d ~/.oh-my-fish 
    echo -e "\033[0;33mYou already have Oh My Fish installed.\033[0m You'll need to remove ~/.oh-my-fish if you want to reinstall it."
    exit
end

echo -e "\033[0;34mCloning Oh My Fish...\033[0m"
git clone https://github.com/bpinto/oh-my-fish.git ~/.oh-my-fish
or begin 
    echo -e "Git is not installed. You need to install at least git-core."
    exit
end

echo -e "\033[0;34mLooking for an existing fish config...\033[0m"
if test -e ~/.config/fish/config.fish
    echo -e "\033[0;33mFound ~/.config/fish/config.fish.\033[0m"
	if contains -- $argv[1] -m -r
		set action (expr substr $argv[1] 2 1)
	else
		read -l -p 'echo "Modify (append needed lines), replace (with backup)? [M/r]: "' action
	end
	if contains $action "" "M" "m"
		echo -e "\033[0;34mUsing the Oh My Fish template file and adding it to the end of ~/.config/fish/config.fish\033[0m"
		echo -e "\n### Oh My Fish configuration\n" >> ~/.config/fish/config.fish
		cat ~/.oh-my-fish/templates/config.fish >> ~/.config/fish/config.fish
	else
		echo -e "\033[0;32mBacking up to ~/.config/fish/config.orig\033[0m"
		mv ~/.config/fish/config.{fish,orig}
		echo -e "\033[0;34mUsing the Oh My Fish template file to replace ~/.config/fish/config.fish\033[0m"
		cp ~/.oh-my-fish/templates/config.fish ~/.config/fish/config.fish
	end
else
	echo -e "\033[0;34mUsing the Oh My Fish template file to create ~/.config/fish/config.fish\033[0m"
	cp ~/.oh-my-fish/templates/config.fish ~/.config/fish/config.fish
end


echo -e "\033[0;32m"'          _                           '"\033[0m"
echo -e "\033[0;32m"'         | |                          '"\033[0m"
echo -e "\033[0;32m"'     ___ | |__    _ __ ___  _   _     '"\033[0m"
echo -e "\033[0;32m"'    / _ \|  _ \  |  _ ` _ \| | | |    '"\033[0m"
echo -e "\033[0;32m"'   | (_) | | | | | | | | | | |_| |    '"\033[0m"
echo -e "\033[0;32m"'    \___/|_| |_| |_| |_| |_|\__, |    '"\033[0m"
echo -e "\033[0;32m"'                             __/ |    '"\033[0m"
echo -e "\033[0;32m"'                            |___/     '"\033[0m"
echo -e "\033[0;32m"'                                      '"\033[0m"
echo -e "\033[0;32m"'                   ___                '"\033[0m"
echo -e "\033[0;32m"'    ___======____=---=)               '"\033[0m"
echo -e "\033[0;32m"'  /T            \_--===)              '"\033[0m"
echo -e "\033[0;32m"'  [ \ (0)   \~    \_-==)              '"\033[0m"
echo -e "\033[0;32m"'   \      / )J~~    \-=)              '"\033[0m"
echo -e "\033[0;32m"'    \\___/  )JJ~~~   \)               '"\033[0m"
echo -e "\033[0;32m"'     \_____/JJ~~~~~    \              '"\033[0m"
echo -e "\033[0;32m"'     / \  , \J~~~~~     \             '"\033[0m"
echo -e "\033[0;32m"'    (-\)\=|\\\~~~~       L__          '"\033[0m"
echo -e "\033[0;32m"'    (\\)  (\\\)_           \==__      '"\033[0m"
echo -e "\033[0;32m"'     \V    \\\) ===_____   \\\\\\     '"\033[0m"
echo -e "\033[0;32m"'            \V)     \_) \\\\JJ\J\)    '"\033[0m"
echo -e "\033[0;32m"'                        /J\JT\JJJJ)   '"\033[0m"
echo -e "\033[0;32m"'                        (JJJ| \UUU)   '"\033[0m"
echo -e "\033[0;32m"'                         (UU)         '"\033[0m"

echo -e "\n\n \033[0;32m....is now installed.\033[0m"

