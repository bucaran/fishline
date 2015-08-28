function omf.remove_package
  for pkg in $argv
    if not omf.util_valid_package $pkg
      switch $pkg
        case "omf" "git"
          echo (omf::err)"You can't remove `$pkg`"(omf::off) 1^&2
        case "*"
          echo (omf::err)"$pkg is not a valid package/theme name"(omf::off) 1^&2
      end
      return $OMF_INVALID_ARG
    end

    if test -d $OMF_PATH/plugin/$pkg
      emit uninstall_$pkg
      printf "%s\n" (sed "/^$pkg\$/d" $OMF_CONFIG/config/plugin) > \
        $OMF_CONFIG/config/plugin
      rm -rf $OMF_PATH/plugin/$pkg
    else if test -d $OMF_PATH/theme/$pkg
      if test $pkg = (cat $OMF_CONFIG/config/theme)
        echo "" > $OMF_CONFIG/config/theme
      end
      rm -rf $OMF_PATH/theme/$pkg
    end

    if test $status -eq 0
      echo (omf::em)"$pkg succesfully removed."(omf::off)
    else
      echo (omf::err)"$pkg could not be found"(omf::off) 1^&2
    end
  end
  refresh
end
