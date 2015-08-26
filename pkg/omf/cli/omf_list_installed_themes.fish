function omf_list_installed_themes
  set -l default (cat $OMF_CONFIG/theme)

  for item in (basename -a $OMF_PATH/themes/*)
    test $item = $default; or echo $item
  end
end
