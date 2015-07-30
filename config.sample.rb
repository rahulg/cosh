# -*- coding: utf-8 -*-

# set an exported env var
var TESTEXPORT, 'foo'

# set a local env var
lvar TESTLOCAL, 'bar'

# set an alias
shalias testalias, 'echo yay'

# single quotes are the default, but we can force them anyway
var TESTSINGLEQUOTES, sq('foo $NOTAVAR')

# use dq if you need "", and var to pick the best variable syntax
var TESTDOUBLEQUOTES, dq('foo ' + variable('TESTLOCAL'))

# use env variables directly
var TESTVARACCESS, "testlocal = #{env.TESTLOCAL}"

# local var with double quotes
lvar TESTQUOTEDLOCAL, dq('oh no $PATH')

# shell commands work too, with the run function
var TESTUNAME, "my uname is #{run('uname', '-a')}"

# $PATH is treated slightly differently, because separators vary between shells
suffix PATH, 'appends', 'these', 'to', 'path'
prefix PATH, 'prepends'

# conditionals can work on shell families…
if shell == :fish
  var MYSHELL, 'fish'
elsif shell == :csh
  var MYSHELL, 'ewwcsh'
elsif shell == :posix
  var MYSHELL, 'yaysh'
end

# or platforms… (as defined by python's sys.platform)
if Platform.darwin?
  var MACUSERS, 'rawr'
end

# or shell names
# this will run only when --shell zsh or -s zsh is passed in
if shell_name == :zsh
  # ruby variables won't leak into the environment
  num = 10
  var NUM, "it is #{num}"
end

# or whatever you like
if 3 % 2 == 1
  puts '# whee'
end

# sometimes you just want to embed some shell commands to be printed verbatim
if shell == :posix
  puts <<-END
  if [[ -f ~/.bash_history ]]; then
    echo YOU HAVE A HISTORY
  fi
  END
end
