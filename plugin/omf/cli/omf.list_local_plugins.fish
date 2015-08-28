# List all custom packages and packages installed from the registry.
function omf.list_local_plugins
  for item in (basename {$OMF_PATH,$OMF_CONFIG}/plugin/*)
    # contains -- $item omf git; or echo $item
    if not test $item = omf
      if not test $item = git
        echo $item
      end
    end
  end
end
