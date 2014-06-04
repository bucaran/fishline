# name:		lolfish
# requires:	jobs, git, hostname, sed
# inspirationk:	lolcat

#
function fish_greeting
end

#
# set the seed color to begin the prompt
#  1 : red
#  6 : yellow
# 11 : green
# 16 : cyan
# 21 : blue
# 26 : magenta
#
set seed_color 21

#
# Rainbows
#
function lolfish -d "very rainbow. wow"

	#
	# valid xterm-256color r g b color space hex values
	# r, g, b can be any of 00, 57, 87, af, d7, ff
	# red    ff0000
	# yellow ffff00
	# green  00ff00
	# blue   0000ff
	#
	set -l colors 	ff0000 ff5700 ff8700 ffaf00 ffd700 \
			ffff00 d7ff00 afff00 87ff00 57ff00 \
			00ff00 00ff57 00ff87 00ffaf 00ffd7 \
			00ffff 00d7ff 00afff 0087ff 0057ff \
			0000ff 5700ff 8700ff af00ff d700ff \
			ff00ff ff00d7 ff00af ff0087 ff0057

	#
	# set the color differential between prompt items.
	# lower values produce a smoother rainbow effect.
	# values between 1 and 5 work the best.
	# 10 has an interesting property.
	# 5 works best for non 256 color terminals.
	#
	set -l color_diff 1

	#
	# set the seed color or default to blue
	#
	if test $seed_color -gt 0
		set color $seed_color
	else
		set seed_color 21
	end

	#
	# reset seed color when it grows beyond the range of valid colors
	#
	if test $seed_color -gt (count $colors)
		set seed_color 1
	end

	#
	# the heart of the matter
	#
	for arg in $argv

		#
		# reset the color to the beginning when it rolls over
		#
		if test $color -gt (count $colors)
			set color 1
		end

		#
		# print these symbols in normal color
		#
		switch $arg
			case '(' ')' '[' ']' ':' '@' ' '
				set_color normal
				echo -n -s $arg
				continue
		end

		#
		# print rainbow!
		#
		set_color $colors[$color]
		echo -n -s $arg

		# color for the next prompt item
		set color (math $color+$color_diff)

	end

	# progress the seed_color for the next line
	set seed_color (math $seed_color+$color_diff)

	# reset
	set_color normal
end

#
# Left prompt
#
function fish_prompt

	#
	# short hostname (non-fully qualified domain name)
	#
	set -l hname (hostname | sed 's/\..*//' ^/dev/null)

	#
	# present working directory (abbreviated home directory ~ )
	#
	set -l pwd (echo $PWD | sed "s,$HOME,~," ^/dev/null)

	#
	# hashtag the prompt for root
	#
	switch $USER
		case 'root'
			set prompt '# '
		case '*'
			set prompt '% '
	end

	#
	# finally print the prompt
	#
	# ssh format prompt, [username@hostname:pwd]%
	#lolfish '[' $USER '@' $hname ':' $pwd ']' $prompt

	# abbreviated prompt, [pwd]%
	lolfish '[' $pwd ']' $prompt
end

#
# Right prompt
#
function fish_right_prompt

	#
	# store the previous command return status for later
	#
	set -l exit_status $status

	#
	# get the number of background jobs
	#
	set -l jobs (count (jobs -p ^/dev/null))

	#
	# when a command errors, display the return value
	# of the last command, [!:exit_status]
	#
	test $exit_status -ne 0; and set -l error '[' '!' ':' $exit_status ']'

	#
	# display the number of background jobs, [&:jobs]
	#
	test $jobs -ne 0; and set -l bjobs '[' '&' ':' $jobs ']'

	#
	# the git bits
	#
	if set -l branch (git rev-parse --abbrev-ref HEAD ^/dev/null)
		set -l git_dirt (count (git status -s --ignore-submodules ^/dev/null))
		test $git_dirt -ne 0; and set -l dirty ':' $git_dirt
		set git '[' $branch $dirty ']'
	end

	# display the number of tmux sessions, [t:tmux_sessions]
	set -l tmux_sessions (count (tmux list-sessions ^/dev/null))
	if test $tmux_sessions -gt 0
		set tmux '[' 't' ':' $tmux_sessions ']'
	end

	# date in default tmux format, [Hour:Minute Day-Month-Year]
	set -l date '[' (date +"%H:%M %d-%m-%Y" ^/dev/null) ']'

	lolfish $git $error $bjobs $tmux $date
end
