# frozen_string_literal: true

require 'etc'
require 'English'
require 'command'
require 'add_line_to_file'
require 'which'

task :fish => [:'fish:setup', :'fish:omf']

namespace :fish do
  desc 'setup fish shell'
  task :setup do
    puts 'Installing fish shell ...'

    command 'sudo', 'apt-add-repository', 'ppa:fish-shell/release-3'
    command 'sudo', 'apt', 'update'
    command 'sudo', 'apt', 'install', 'fish'

    fish_executable = (which 'fish')
    add_line_to_file '/etc/shells', fish_executable

    unless ENV['SHELL'].eql? fish_executable
      command 'sudo', '/usr/bin/chsh', '-s', fish_executable, Etc.getlogin
    end

    fish_config = "#{ENV['HOME']}/.config/fish/config.fish"
    FileUtils.mkdir_p File.dirname(fish_config)
    FileUtils.cp "#{__dir__}/../../res/configs/config.fish", File.dirname(fish_config)

    brew_prefix = '/home/linuxbrew/.linuxbrew'

    if !File.directory? brew_prefix
      brew_prefix = "#{ENV['HOME']}/.linuxbrew"
    end

    add_line_to_file fish_config, "eval (#{brew_prefix}/bin/brew shellenv)"
  end

  desc 'setup oh-my-fish and plugins'
  task :omf do
    next unless OS.linux? and !ENV['CI']

    if !ENV['OMF_CONFIG']
      puts 'Installing oh-my-fish ...'
      Open3.pipeline ['curl', '-L', 'https://get.oh-my.fish'], ['fish']
    end

    [
      'z',
      'bobthefish',
      'fish_logo',
      'https://github.com/danhper/fish-ssh-agent',
      'rustup'
    ].each do |plugin|
      command 'fish', '-c', "omf install #{plugin}"
    end

    command 'fish', '-c', 'omf update'
    command 'fish', '-c', 'omf install'

    FileUtils.cp "#{__dir__}/../../res/configs/fish_greeting.fish", "#{ENV['HOME']}/.config/fish/functions"
  end
end