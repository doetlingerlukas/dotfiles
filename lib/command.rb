# frozen_string_literal: true

require 'open3'
require 'English'
require 'shellwords'

def ps_command(command)
  Open3.capture3('powershell', '-command', "#{command}")
end

def command(*args)
  system *args
  return if $CHILD_STATUS.success?
  raise "Command '#{args.shelljoin}' failed." if ENV['CI']
end
