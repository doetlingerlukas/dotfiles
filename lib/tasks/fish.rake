# frozen_string_literal: true

require 'os'
require 'command'
require 'add_line_to_file'
require 'which'

task :fish => [:'fish:install']

namespace :fish do
  desc 'Install fish shell.'
  task :install do
    next unless OS.linux?

    puts 'Installing fish shell.'
    command 'sudo', 'apt-add-repository', 'ppa:fish-shell/release-3', '-y'
    command 'sudo', 'apt-get', 'update'
    command 'sudo', 'apt-get', 'install', 'fish', '-y'

    fish_executable = (which 'fish')
    add_line_to_file '/etc/shells', fish_executable

    unless ENV['SHELL']
      username = `whoami`
      command 'sudo', '/usr/bin/chsh', '-s', fish_executable, username
    end
  end
end