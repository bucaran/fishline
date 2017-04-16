function yin
  if [ -f /usr/bin/dnf ]
    set pkgmgr dnf
  else
    set pkgmgr yum
  end

  switch "$pkgmgr"
    case dnf
      sudo dnf install $argv
    case yum
      sudo yum install $argv
  end
end
