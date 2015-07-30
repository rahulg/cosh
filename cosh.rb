#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'optparse'
require 'ostruct'

Options = Struct.new(:shell)

class Parser
  def self.parse(options)
    args = Options.new :sh

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage cosh.rb [options] [config.rb]'
      opts.on('-sSHELL', '--shell=SHELL', 'target shell syntax') do |shell|
        args.shell = shell.to_sym
      end
      opts.on('-h', '--help', 'prints this help') do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    args
  end
end

module Platform
  def self.darwin?
    (/darwin/ =~ RbConfig::CONFIG['host_os']) != nil
  end

  def self.linux?
    !Platform.darwin?
  end
end

class Shell
  def initialize(shell_name)
    @env = OpenStruct.new ENV
    @shell_name = shell_name.to_sym
  end

  attr_accessor :env, :shell_name

  def run(*cmd)
    IO.popen(cmd.join ' ').gets.strip
  end

  def dq(val)
    %("#{val.gsub %("), %q(\")}")
  end

  def sq(val)
    %('#{val.gsub %('), %q(\')}')
  end

  def sqvar(key, val)
    var key, (sq val)
  end

  def dqvar(key, val)
    var key, (dq val)
  end

  def quote(val)
    val = val.to_s
    if val.start_with?(%(')) || val.start_with?(%("))
      val
    else
      sq val
    end
  end

  def self.const_missing(name)
    name
  end

  def bind
    def self.method_missing(symbol, *_args, &_blk)
      symbol
    end

    binding
  end
end

class Posix < Shell
  def shell
    :posix
  end

  def self.shells
    [:posix, :sh, :bash, :ash, :dash, :ksh, :zsh]
  end

  def variable(name)
    "${#{name}}"
  end

  def lvar(key, val)
    env['key'] = val
    puts "#{key}=#{quote val}"
  end

  def var(key, val)
    env['key'] = val
    puts "export #{key}=#{quote val}"
  end

  def array(*vals)
    vals.join(':')
  end

  def prefix(key, *vals)
    dqvar key, array(*vals, (variable key))
  end

  def suffix(key, *vals)
    dqvar key, array((variable key), *vals)
  end

  def alias(key, val)
    puts "alias #{key}=#{quote val}"
  end

  alias_method :abbr, :alias
end

class Fish < Shell
  def shell
    :fish
  end

  def self.shells
    [:fish]
  end

  def variable(name)
    "$#{name}"
  end

  def lvar(key, val)
    env['key'] = val
    puts "set #{key} #{quote val}"
  end

  def unquoted_var(key, val)
    puts "set -x #{key} #{val}"
  end

  def var(key, val)
    env['key'] = val
    puts "set -x #{key} #{quote val}"
  end

  def array(*vals)
    quoted_vals = vals.map { |v| dq v }
    quoted_vals.join(' ')
  end

  def prefix(key, *vals)
    unquoted_var key, array(*vals, (variable key))
  end

  def suffix(key, *vals)
    unquoted_var key, array((variable key), *vals)
  end

  def alias(key, val)
    puts "alias #{key} #{quote val}"
  end

  def abbr(key, val)
    puts "abbr #{key} #{quote val}"
  end
end

handlers = [Fish, Posix]
handler_map = {}

handlers.each do |hnd|
  hnd.shells.each do |sh|
    handler_map[sh] = hnd
  end
end

options = Parser.parse ARGV

unless handler_map.key? options.shell
  puts "Unknown shell #{options.shell}"
  exit 1
end

handler = handler_map[options.shell].new options.shell

eval ARGF.read, handler.bind
