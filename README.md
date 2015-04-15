# cosh

`cosh` is a small python utility that allows you to generate a common environment configuration (variables and aliases) for multiple shells that may not share a common syntax.

It's not likely to be useful to you unless you use `fish` / `csh` along with the `sh` family of shells.

It currently supports the following families:

* the POSIXy family: `sh` `bash` `ash` `dash` `ksh` `zsh`
* csh family: `csh` `tcsh`
* fish family: `fish`

## Requirements

* python 2.7 or 3.\*
* any of the supported shells

## Usage

Add something like the following to your shell's startup script (`bashrc`, `cshrc`, `config.fish`):

```sh
# sh-like
eval $( cosh ~/.config/cosh/config.py )
# or bash
# eval $( cosh --shell bash ~/.config/cosh/config.py )
```

```csh
# csh-like
eval `cosh --shell csh ~/.config/cosh/config.py`
```

```fish
# fish
eval (cosh --shell fish ~/.config/cosh/config.py)
```

It's recommended that you use the actual shell name, since that lets you do some fancy stuff in the config.

## config.py syntax

`config.py` is a standard python file that gets	`exec`ed by `cosh`. Any python statement should work in it. Refer to the enclosed `config.sample.py` for more details.

## The Name

`cosh` is short for common shell.
