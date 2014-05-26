## lolprompt

lolprompt is a Git-aware fish theme inspired by [lolcat][lolcat] and [bobthefish][bobthefish].

![lolprompt][screenshot]

You will not need any special patched fonts for this to work.


### Features

 * bobthefish's helpful, but not too distracting, greeting.
 * bobthefish's subtle timestamp hanging out off to the right.
 * Wow such color
 * Some of the things you need to know about Git in a glance.
 * A return value from the last command if there was an error.


### The Prompt

 * ssh standard user@host:path format
 * Current project's Git branch: (master)
 * Number of dirty files in the Git project: (master:3)
 * Exit status of previous command: exit(!0)
 * Flags:
     * You currently are a normal user [%]
     * You currently are root [#]

[screenshot]: http://i.imgur.com/4szYYdt.png?1
[lolcat]:     https://pypi.python.org/pypi/lolcat/0.42.42
[bobthefish]: https://github.com/bpinto/oh-my-fish/tree/master/themes/bobthefish  
