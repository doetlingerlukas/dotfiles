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

    snap_yaml = YAML.load_file(File.join(__dir__, '../../res/snap.yaml'))

    snap_yaml['snaps'].each do |s|
      puts "Installing snap '#{s}'."
      system 'sudo', 'snap', 'install', s.split
      unless $CHILD_STATUS.success?
        raise "Installing snap '#{s}' failed."
      end
    end

  end
end