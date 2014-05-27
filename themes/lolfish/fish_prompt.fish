# name:		lolfish
# requires:	git, hostname, sed, tr, wc
# thanks:	mostly copied from the robbyrussell theme
# 		inspired by lolcat python script and bobthefish theme

function fish_prompt

	# store the previous command return status for later
	set -l prev_status $status

	# color settings
	set -l normal	(set_color normal)
	set -l purple	(set_color af00d7)
	set -l blue	(set_color blue)
	set -l green	(set_color green)
	set -l yellow	(set_color yellow)
	set -l orange	(set_color d75f5f)
	set -l red	(set_color red)

	# set the user, short hostname (non-fully qualified domain name)
	# and current path (abbreviated home directory ~ ) in the standard
	# ssh style format
	set -l uname	$normal ''	$purple	$USER					$normal	'@'
	set -l hname	$normal	''	$blue	(hostname | sed 's/\..*//' ^/dev/null)	$normal	':'
	set -l cwd	$normal	''	$green	(pwd | sed "s,$HOME,~," ^/dev/null)	$normal	' '

	# the git bits
	if set -l branch (git rev-parse --abbrev-ref HEAD ^/dev/null)
		set -l files (git status -s --ignore-submodules ^/dev/null | wc -l | tr -d ' ')
		test $files -ne 0; and set -l dirty $normal ':' $red $files
		set git $yellow 'git' $normal '[' $orange $branch $dirty $normal '] '
	end

	# display the return value of the last command
	# only if the command produced an error
	test $prev_status -ne 0; and set -l error $normal '![' $red $prev_status $normal '] '

	# hashtag the prompt for root
	switch $USER
		case 'root'
			set prompt $normal '# '
		case '*'
			set prompt $normal '% '
	end

	# finally print the prompt
	echo -n -s $uname $hname $cwd $git $error $prompt
end
