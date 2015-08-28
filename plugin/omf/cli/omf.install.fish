function omf.install -a type name_or_url
  switch $type
    case "--theme"
      set type "theme"
    case "--plugin"
      set type "plugin"
    case "*"
      echo (omf::err)"Argument to omf.install must be --theme [name|URL] or --plugin [name|URL]"(omf::off)
      return $OMF_INVALID_ARG
  end

  if test -e $OMF_PATH/db/$type/$name_or_url
    set target $type/$name_or_url
    if test -e $OMF_PATH/$target
      echo (omf::dim)"Updating $name_or_url $type..."(omf::off)
      pushd $OMF_PATH/$target
      omf.util_sync "origin" >/dev/null ^&1
      popd
      echo (omf::em)"✔ $name_or_url $type up to date."(omf::off)
    else
      echo (omf::dim)"Installing $name_or_url $type..."(omf::off)
      if git clone (cat $OMF_PATH/db/$target) $OMF_PATH/$target >/dev/null ^&1
        echo (omf::em)"✔ $name_or_url $type successfully installed."(omf::off)
      else
        echo (omf::err)"Could not install $type."(omf::off) 1^&2
        return $OMF_UNKNOWN_ERR
      end
    end
  else
    set -l base (basename $name_or_url)
    if test -e $OMF_PATH/$type/$base
      echo (omf::err)"Error: $base $type already installed."(omf::off) 1^&2
      return $OMF_INVALID_ARG
    else
      echo (omf::dim)"Cloning $base from $name_or_url..."(omf::off)
      if git clone -q $name_or_url $OMF_PATH/$type/$base
        echo (omf::em)"✔ $base $type succesfully installed."(omf::off)
      else
        echo (omf::err)"$base is not a valid $type."(omf::off) 1^&2
        return $OMF_INVALID_ARG
      end
    end
  end

  if test $type = plugin
    echo "$name_or_url" >> "$OMF_CONFIG/config/plugin"
    if test -e $OMF_PATH/plugin/$name_or_url/deps
      echo (omf::em)"Installing dependencies for $name_or_url $type..."(omf::off)
      for dep in (cat $OMF_PATH/plugin/$name_or_url/deps)
        omf.install --plugin $dep
      end
    end
  else
    echo "$name_or_url" > $OMF_CONFIG/config/theme
  end
end
