function yup
  if [ -f /usr/bin/dnf ]
    set pkgmgr dnf
  else
    set pkgmgr yum
  end

  switch "$pkgmgr"
    case dnf
      sudo dnf update $argv
    case yum
      sudo yum update $argv
  end
end
