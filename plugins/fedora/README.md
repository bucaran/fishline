## Fedora

Port of TingPing's [fedora.plugin.zsh](https://github.com/TingPing/zsh/blob/master/plugins/fedora/fedora.plugin.zsh)

#### commands (compatible with both yum and dnf)
yse  = $pkgmgr search  
ypro = $pkgmgr provides  
yinf = $pkgmgr info  
ygl  = $pkgmgr list  
yup  = sudo $pkgmgr update  
yin  = sudo $pkgmgr install  
yrm  = sudo $pkgmgr erase  

#### yum-utils
ybd = sudo yum-builddep  
yls = repoquery -l  
yds = yumdownloader --source
