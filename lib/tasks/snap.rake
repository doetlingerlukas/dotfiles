# frozen_string_literal: true

require 'os'
require 'yaml'
require 'English'
require 'distro'
require 'command'

task :snap => [:'snap:install']

namespace :snap do
  desc 'install snap apps'
  task :install do
    next unless OS.linux? && !wsl?

    command 'sudo', 'apt', 'install', 'snapd', '-y'

    linux_packages = YAML.load_file(File.join(__dir__, '../../res/linux.yaml'))

    linux_packages['snap'].each do |s|
      puts "Installing snap '#{s}'."
      system *['sudo', 'snap', 'install'].push(*s.split)
      unless $CHILD_STATUS.success?
        raise "Installing snap '#{s}' failed."
      end
    end

  end
end