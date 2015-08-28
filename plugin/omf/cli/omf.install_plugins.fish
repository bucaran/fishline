function omf.install_plugins
  for search in $argv
    omf.install --plugin $search
  end
end
