# -*- coding: utf-8 -*-

# set an exported env var
env.TESTEXPORT = 'foo'

# set a local env var
env.TESTLOCAL = LVar('bar')

# set an alias
env.testalias = Alias('echo yay')

# single quotes are the default, but we can force them anyway
env.TESTSINGLEQUOTES = sq('foo $NOTAVAR')

# use dq if you need "", and var to pick the best variable syntax
env.TESTDOUBLEQUOTES = dq('foo ' + var('TESTLOCAL'))

# local var with double quotes
env.TESTQUOTEDLOCAL = LVar(dq('oh no $PATH'))

# shell commands work too, with the run function
env.TESTUNAME = 'my uname is %s' % run('uname', '-a')

# $PATH is treated slightly differently, because separators vary between shells
# mnemonic: _s -> suffix, _p -> prefix
env.path_s('appends', 'these', 'to', 'path')
env.path_p('prepends')

# conditionals can work on shell families…
if shell is Fish:
    env.MYSHELL = 'fish'
elif shell is Csh:
    env.MYSHELL = 'ewwcsh'
elif shell is Posix:
    env.MYSHELL = 'yaysh'

# or platforms… (as defined by python's sys.platform)
if platform == 'darwin':
    env.MACUSERS = 'rawr'

# or shell names
# this will run only when --shell zsh or -s zsh is passed in
if shell_name == 'zsh':
    # python variables won't leak into the environment
    num = 10
    env.NUM = num * 10

# or whatever you like
if 3 % 2 == 1:
    pass

# sometimes you just want to embed some shell commands to be printed verbatim
if shell is Posix:
    verbatim('''
    if [[ -f ~/.bash_history ]]; then
        echo YOU HAVE A HISTORY
    fi
    ''')
