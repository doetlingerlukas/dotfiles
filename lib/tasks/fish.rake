# frozen_string_literal: true

require 'os'
require 'command'
require 'add_line_to_file'
require 'which'

task :fish => [:'fish:setup']

namespace :fish do
  desc 'Setup fish shell.'
  task :setup do
    next unless OS.linux?

    puts 'Setting fish as default shell shell.'

    fish_executable = (which 'fish')
    add_line_to_file '/etc/shells', fish_executable

    unless ENV['SHELL'].eql? fish_executable
      command 'sudo', '/usr/bin/chsh', '-s', fish_executable
    end
  end
end