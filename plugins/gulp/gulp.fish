function __fish_print_tasks --description 'Print gulp tasks'
  cat (pwd)/gulpfile.js | awk '/gulp.task\((\'|").*(\'|"),/ {print $1}' | sed -E 's/gulp.task\((\'|")(.*)(\'|"),/\2/g'
end

complete -c gulp -f -a '(__fish_print_tasks)' -d 'Gulp task'
