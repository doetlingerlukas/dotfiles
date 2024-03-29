# frozen_string_literal: true

require 'yaml'
require 'command'

task :brew => [:'brew:installs']

namespace :brew do
  desc 'install brew apps'
  task :installs do
    brew_yaml = YAML.load_file(File.join(__dir__, '../../res/brew.yaml'))

    brew_yaml['packages'].each do |s|
      command 'brew', 'install', s
    end
  end
end
