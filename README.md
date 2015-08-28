
> The [Fishshell][fishshell] Framework

[![Fish Version][fish-badge]][fishshell]
[![Build Status][travis-badge]][travis-url]
[![License][license-badge]](#LICENSE)

<a name="omf"></a>
<br>

<p align="center">
:warning:
<h5 align="center">
<a href="https://github.com/wa/wahoo">Wahoo</a> and <a href="https://github.com/oh-my-fish/oh-my-fish">Oh My Fish!</a> are now _one_ project. See this page and <a href="FAQ.md">FAQ</a> to learn what's new.
</h5>
</p>

<hr>


<br>

<p align="center">
  <a href="https://github.com/fish-shell/oh-my-fish/blob/master/README.md">
  <img width="140px" src="https://cloud.githubusercontent.com/assets/8317250/8510172/f006f0a4-230f-11e5-98b6-5c2e3c87088f.png">
  </a>
</p>

<br>

<p align="center">
<b><a href="#about">About</a></b>
|
<b><a href="#install">Install</a></b>
|
<b><a href="#getting-started">Getting Started</a></b>
|
<b><a href="#advanced">Advanced</a></b>
|
<b><a href="https://github.com/fish-shell/oh-my-fish/wiki/Screencasts">Screencasts</a></b>
|
<b><a href="/CONTRIBUTING.md">Contributing</a></b>
|
<b><a href="/FAQ.md">FAQ</a></b>

  <p align="center">
    <a href="https://gitter.im/fish-shell/oh-my-fish?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge">
      <img src="https://badges.gitter.im/Join%20Chat.svg">
    </a>
  </p>
</p>

<br>

# About

Oh My Fish! is an all-purpose framework for [fish][Fishshell]. It looks after your configuration, themes and plugins. It's lightning fast and easy to use.

We love contributions, [fork and send us a PR](https://github.com/fish-shell/oh-my-fish/fork).

# Install

```fish
curl -L git.io/omf | sh
omf help
```

Or _download_ and run it yourself:

```fish
curl -L git.io/omf > install
chmod +x install
./install
```

# :beginner: Getting Started

Oh My Fish! adds `omf` to your shell to fetch and install new plugins and themes.

## `omf install` _`<plugin> ...`_

Install one _or more_ themes or plugins. To list available plugins type `omf theme`.

> You can fetch plugins by URL as well via `omf install URL`

## `omf list`

List installed plugins.

> To list plugins available for download use `omf install`.

## `omf theme` _`<theme>`_

Apply a theme. To list available themes type `omf theme`.

## `omf remove` _`<name>`_

Remove a theme or plugin.

> Packages subscribed to `uninstall_<plugin>` events are notified before the plugin is removed to allow custom cleanup of resources. See [Uninstall](#uninstall).

## `omf update`

Update framework and installed plugins.

## `omf new plugin | theme` _`<name>`_

Scaffold out a new plugin or theme.

> This creates a new directory under `$OMF_CONFIG/{plugin | themes}/` with a template.

## `omf submit` _`plugin/<name>`_ _`[<url>]`_

Add a new plugin. To add a theme use `omf submit` _`themes/<name>`_ _`<url>`_.

Make sure to [send us a PR][omf-pulls-link] to update the registry.

## `omf query` _`<variable name>`_

Use to inspect all session variables. Useful to  dump _path_ variables like `$fish_function_path`, `$fish_complete_path`, `$PATH`, etc.

## `omf destroy`

Uninstall Oh My Fish!. See [uninstall](#uninstall) for more information.

# :triangular_flag_on_post: Advanced
+ [Startup](#startup)
+ [Core Library](#core-library)
+ [Packages](#plugins)
  + [Creating](#creating)
  + [Submitting](#submitting)
  + [Initialization](#initialization)
  + [Uninstall](#uninstall)
  + [Ignoring](#ignoring)

## Startup

This script runs each time a new session begins, autoloading plugins, themes and your _config_ path in that order.

The _config_ path (`~/.config/omf` by default) is defined by `$OMF_CONFIG` in `~/.config/fish/config.fish`. Modify this to load your own configuration, if you have any, as discussed in the [FAQ](FAQ.md#what-does-oh-my-fish-do-exactly).

## Core Library

The core library is a minimum set of basic utility functions that extend your shell.

+ [See the documentation](/lib/README.md).


## Packages
### Creating

> A plugin/theme name may only contain lowercase letters and hyphens to separate words.

To scaffold out a new plugin:

```fish
$ omf new plugin my_package

my_package/
  README.md
  my_package.fish
  completions/my_package.fish
```

> Use `omf new theme my_theme` for themes.

Please provide [auto completion](http://fishshell.com/docs/current/commands.html#complete) for your utilities if applicable and describe how your plugin works in the `README.md`.


`my_package.fish` defines a single function:

```fish
function my_package -d "My plugin"
end
```

> Bear in mind that fish lacks a private scope so consider the following options to avoid polluting the global namespace:

+ Prefix functions: `my_package_my_func`.
+ Using [blocks](http://fishshell.com/docs/current/commands.html#block).


### Submitting

Oh My Fish! keeps a registry of plugins under `$OMF_PATH/db/`.

To create a new entry run:

```fish
omf submit plugin/my_package .../my_package.git
```

Similarly for themes use:

```fish
omf submit theme/my_theme .../my_theme.git
```

This will add a new entry to your local copy of the registry. Please [send us a PR][omf-pulls-link] to update the global registry.


### Initialization

If you want to be [notified](http://fishshell.com/docs/current/commands.html#emit) when your plugin loads, create a function in your `my_package.fish` such as:

```fish
function init -a path --on-event init_myplugin
end
```

Use this event to modify the environment, load resources, autoload functions, etc. If your plugin does not export any functions, you can still use this event to add functionality to your plugin.

### Uninstall

Oh My Fish! emits `uninstall_<plugin>` events before a plugin is removed via `omf remove <plugin>`. Subscribers can use the event to clean up custom resources, etc.

```fish
function uninstall --on-event uninstall_plugin
end
```

### Ignoring

Remove any plugins you wish to turn off using `omf remove <plugin name>`. Alternatively, you can set a global env variable `$OMF_SKIP` in your `~/.config/fish/config.fish` with the plugins you wish to ignore. For example:

```fish
set -g OMF_SKIP skip this that ...
```


# License

MIT © [Oh My Fish!][contributors] :metal:

[fishshell]: http://fishshell.com

[contributors]: https://github.com/fish-shell/oh-my-fish/graphs/contributors

[travis-badge]: http://img.shields.io/travis/fish-shell/oh-my-fish.svg?style=flat-square
[travis-url]: https://travis-ci.org/fish-shell/oh-my-fish

[fish-badge]: https://img.shields.io/badge/fish-v2.2.0-007EC7.svg?style=flat-square

[license-badge]: https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square

[omf-pulls-link]: https://github.com/fish-shell/oh-my-fish/pulls
