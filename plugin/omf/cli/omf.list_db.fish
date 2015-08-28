# List all packages available to install from the registry.
function omf.list_db
  for item in (basename $OMF_PATH/db/plugin/*)
    contains $item (basename {$OMF_PATH,$OMF_CONFIG}/plugin/*); or echo $item
  end
end
