function omf.util_valid_package -a name
  switch (echo "$name" | tr "[:upper:]" "[:lower:]" | tr -d " ")
    case "git" "omf"
      return 1
  end
  switch $name
    case {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}\*
      switch $name
        case "*/*" "* *" "*&*" "*\"*" "*!*" "*&*" "*%*" "*#*"
          return 1
        case "*"
          return 0
      end
    case "*"
      return 1
  end
end
