function omf.list_themes
  set -l seen ""
  for theme in (basename $OMF_PATH/db/themes/*) \
               (basename {$OMF_PATH,$OMF_CUSTOM}/themes/*)
    contains $theme $seen; or echo $theme
    set seen $seen $theme
  end
end
