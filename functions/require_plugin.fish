# Load plugin and dependencies.
# @params <plugin_name>[..]
function require_plugin -d "Load a plugin list and dependencies."
  for plugin in $argv
    _fish_add_plugin $plugin
    _fish_add_completion $plugin
    _fish_source_plugin_load_file $plugin
  end
end
