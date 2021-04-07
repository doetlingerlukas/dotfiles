# frozen_string_literal: true

require 'open3'
require 'English'
require 'shellwords'

def ps_command(command)
  Open3.capture3('powershell', '-command', "#{command}")
end

def capture_pwsh(*args)
  out, err, status = Open3.capture3('pwsh', '-command', "#{args.join(' ')}")
  return out if status.success?
  raise "Command '#{args.join(' ')}' failed with '#{err}'"
end

def pwsh(*args)
  system 'pwsh', '-command', "#{args.join(' ')}"
  return if $CHILD_STATUS.success?
  raise "Command '#{args.shelljoin}' failed." if ENV['CI']
end

def command(*args)
  system *args
  return if $CHILD_STATUS.success?
  raise "Command '#{args.shelljoin}' failed." if ENV['CI']
end

def wsl(distro, *args)
  system 'wsl', '-d', "#{distro}", *args
  return if $CHILD_STATUS.success?
  raise "WSL command '#{args.shelljoin}' failed in #{distro}." if ENV['CI']
end