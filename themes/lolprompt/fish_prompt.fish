# name:     lolprpmpt
# requires: git, hostname, tr, wc, whoami
# thanks:   mostly copied from the robbyrussell theme
#           inspired by lolcat python script and bobthefish theme

function fish_prompt

	# store the previous command return status for later
	set -l cmdsts $status

	# color settings
	set -l normal (set_color -o normal)
	set -l purple (set_color -o 60f)
	set -l blue   (set_color -o blue)
	set -l green  (set_color -o green)
	set -l yellow (set_color -o yellow)
	set -l orange (set_color -o f60)
	set -l red    (set_color -o red)

	# set the user, short hostname (non-fully qualified domain name)
	# and current path in the standard ssh style format
	set -l me    $purple (whoami)      $normal '@'
	set -l nfqdn $blue   (hostname -s) $normal ':'
	set -l cwd   $green  (prompt_pwd)  $normal ' '

	# the git bits
	if set -l branch (git rev-parse --abbrev-ref HEAD ^/dev/null)
		set -l files (git status -s --ignore-submodules ^/dev/null | wc -l | tr -d ' ')
		test $files -ne 0; and set -l dirty $normal ':' $red $files
		set git $yellow 'git' $normal '(' $orange $branch $dirty $normal ') '
	end

	# display the return value of the last command
	# only if the command produced an error
	test $cmdsts -ne 0; and set -l error $normal 'exit(' $red $cmdsts $normal ') '

	# hashtag the prompt for root
	switch $USER
		case 'root'
			set prompt $normal '# '
		case '*'
			set prompt $normal '% '
	end

	# finally print the prompt
	echo -n -s $me $nfqdn $cwd $git $error $prompt
end
