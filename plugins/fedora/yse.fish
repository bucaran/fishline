function yse
  if [ -f /usr/bin/dnf ]
    set pkgmgr dnf
  else
    set pkgmgr yum
  end

  switch "$pkgmgr"
    case dnf
      dnf search $argv
    case yum
      yum search $argv
  end
end
