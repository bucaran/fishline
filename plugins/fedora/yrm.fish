function yrm
  if [ -f /usr/bin/dnf ]
    set pkgmgr dnf
  else
    set pkgmgr yum
  end

  switch "$pkgmgr"
    case dnf
      sudo dnf erase $argv
    case yum
      sudo yum erase $argv
  end
end
