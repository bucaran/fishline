function ypro
  if [ -f /usr/bin/dnf ]
    set pkgmgr dnf
  else
    set pkgmgr yum
  end

  switch "$pkgmgr"
    case dnf
      dnf provides $argv
    case yum
      yum provides $argv
  end
end
