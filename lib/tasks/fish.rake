# frozen_string_literal: true

require 'os'
require 'etc'
require 'English'
require 'command'
require 'add_line_to_file'
require 'which'

task :fish => [:'fish:setup', :'fish:omf']

namespace :fish do
  desc 'setup fish shell'
  task :setup do
    next unless OS.linux?

    puts 'Setting fish as default shell ...'

    fish_executable = (which 'fish')
    add_line_to_file '/etc/shells', fish_executable

    unless ENV['SHELL'].eql? fish_executable
      command 'sudo', '/usr/bin/chsh', '-s', fish_executable, Etc.getlogin
    end
  end

  desc 'setup oh-my-fish and plugins'
  task :omf do
    next unless OS.linux?

    if (which 'omf').nil?
      puts 'Installing oh-my-fish ...'
      command 'curl', '-L', 'https://get.oh-my.fish', '|', 'fish'
    end

    [
      'z',
      'https://github.com/jethrokuan/fzf',
      'brew',
      'grc'
    ].each do |plugin|
      command 'omf', 'install', plugin
    end

    command 'omf', 'update'
    command 'omf', 'install'
  end
end