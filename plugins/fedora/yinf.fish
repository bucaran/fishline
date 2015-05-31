function yinf
  if [ -f /usr/bin/dnf ]
    set pkgmgr dnf
  else
    set pkgmgr yum
  end

  switch "$pkgmgr"
    case dnf
      dnf info $argv
    case yum
      yum info $argv
  end
end
