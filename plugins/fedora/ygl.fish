function ygl
  if [ -f /usr/bin/dnf ]
    set pkgmgr dnf
  else
    set pkgmgr yum
  end

  switch "$pkgmgr"
    case dnf
      dnf list $argv
    case yum
      yum list $argv
  end
end
