# frozen_string_literal: true

require 'os'
require 'etc'
require 'English'
require 'command'
require 'add_line_to_file'
require 'which'

task :fish => [:'fish:setup', :'fish:fisher']

namespace :fish do
  desc 'Setup fish shell.'
  task :setup do
    next unless OS.linux?

    puts 'Setting fish as default shell.'

    fish_executable = (which 'fish')
    add_line_to_file '/etc/shells', fish_executable

    unless ENV['SHELL'].eql? fish_executable
      command 'sudo', '/usr/bin/chsh', '-s', fish_executable, Etc.getlogin
    end
  end

  desc 'Setup fisher and plugins.'
  task :fisher do
    next unless OS.linux?
    next if ENV['CI']

    begin
      command 'fish', '-c', 'fisher -v'
      raise "Fisher not installed!" unless $CHILD_STATUS.success?
    rescue StandardError => e
      puts 'Installing fischer.'
      command 'curl', 'https://git.io/fisher', '--create-dirs', '-sLo', ENV['HOME']+'/.config/fish/functions/fisher.fish'
    end

    puts 'Updating fischer plugins.'
    [
      'jethrokuan/z',
      'franciscolourenco/done',
      'jorgebucaran/fish-spark',
    ].each do |plugin| 
      command 'fish', '-c', "fisher add #{plugin}"
    end
    command 'fish', '-c', 'fisher'

  end
end