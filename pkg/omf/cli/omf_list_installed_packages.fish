# List all packages installed from the registry.
function omf_list_installed_packages
  for item in (basename -a $OMF_PATH/pkg/*)
    test $item = omf; or echo $item
  end
end
