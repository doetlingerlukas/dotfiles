# frozen_string_literal: true

require 'os'
require 'yaml'
require 'command'

task :brew => [:'brew:installs']

namespace :brew do
  desc 'install brew apps'
  task :installs do
    next unless OS.linux?

    brew_yaml = YAML.load_file(File.join(__dir__, '../../res/linux.yaml'))

    brew_yaml['packages'].each do |s|
      command 'brew', 'install', s
    end

  end
end