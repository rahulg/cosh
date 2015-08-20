# cosh

`cosh` is a small ruby utility that generates a shell environment & alias configuration for multiple shells that don't share a common syntax.

It currently supports the following families:

* the POSIXy family: `sh` `bash` `ash` `dash` `ksh` `zsh`
* csh family: `csh` `tcsh`
* fish family: `fish`

## Requirements

* ruby 2.2 (probably works with 2.0+)
* any of the supported shells

## Usage

Add something like the following to your shell's startup script (`bashrc`, `cshrc`, `config.fish`):

```sh
# sh-like
# NOTE: sourcing a process-substitution may not work on other sh-like shells
# and will not work on old versions of bash
source <( cosh --shell bash ~/.config/cosh/config.rb )
```

```csh
# csh-like
set rc=/tmp/cshrc-`date +s`
cosh --shell csh ~/.config/cosh/config.rb >${rc} && source ${rc} && rm ${rc}
```

```fish
# fish
source ( cosh --shell fish ~/.config/cosh/config.rb | psub )
```

It's recommended that you use the actual shell name, since that lets you do some fancy conditionals in the config.

## config.rb syntax

`config.rb` is a standard ruby file that gets `eval`ed by `cosh`. Any standard ruby should work in it, and there's a basic DSL for common operations.

Example:

* `var foo, 'bar'` sets an exported variable `foo` to `bar`
* `lvar bar, 'baz'` sets a local variable `bar` to `baz`
* `alias foo, 'bar'` creates an alias named `foo`, which will run `bar` when run

Refer to `config.sample.rb` for more details.
