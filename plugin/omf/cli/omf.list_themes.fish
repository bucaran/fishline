function omf.list_themes
  set -l seen ""
  for theme in (basename $OMF_PATH/db/theme/*) \
               (basename {$OMF_PATH,$OMF_CONFIG}/theme/*)
    contains $theme $seen; or echo $theme
    set seen $seen $theme
  end
end
