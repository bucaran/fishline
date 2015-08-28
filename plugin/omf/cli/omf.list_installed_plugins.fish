# List all plugins installed from the registry.
function omf.list_installed_plugins
  for item in (basename $OMF_PATH/plugin/*)
    test $item = omf; or echo $item
  end
end
