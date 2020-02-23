#!/usr/bin/env ruby

require 'yaml'
require 'English'

gems = YAML.load_file('gems.yaml')

gems.gems.each do |g|
  puts "Installing ruby gem '#{g}."
  system 'sudo', 'gem', 'install', g
  unless $CHILD_STATUS.success?
    raise "Installing ruby gem '#{g}' failed."
  end
end

linux_packages = YAML.load_file('linux.yaml')

linux_packages.apt.each do |pkg|
  puts "Installing apt package '#{pkg}'."
  system 'sudo', 'apt', 'install', pkg, '-y'
  unless $CHILD_STATUS.success?
    raise "Installing apt package '#{pkg}' failed."
  end
end

linux_packages.snap.each do |s|
  puts "Installing snap '#{s}'."
  system 'sudo', 'snap', 'install', s
  unless $CHILD_STATUS.success?
    raise "Installing snap '#{s}' failed."
  end
end