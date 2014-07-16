# Custom Theme

### Why ?
  If you want to tinker with your favorite theme, custom-theme will tell you on a pull if an update has been done on the theme.

### What does it do ?

  The Plugin will check the latest commit of `(oh-my-fish-path)/themes/$fish_theme/fish_prompt.fish` and `(oh-my-fish-path)/themes/$fish_theme/fish_right_prompt.fish`.
  
  If this commit is more recent than the commit it has previously seen, custom-theme will print a warning.
  To aknowledge this warning, just update your custom theme or `touch (oh-my-fish-path)/themes/$fish_theme/fish_prompt.fish`


### Other Features

  Many themes use color and unicode that doesn't really fit a system tty ;
  * This is why custom-theme also perform a fallback on system `fish_prompt` if it detect that fish is launched from a ttyX.


### How to use ?

  This plugin also have a folder in `themes`, do not worry about that just add this plugin like any other `set fish_plugin custom-theme`
