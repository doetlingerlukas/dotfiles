#!/usr/bin/env ruby

require 'yaml'
require 'English'

gems = YAML.load_file(File.join(__dir__, 'gems.yaml'))

gems['gems'].each do |g|
  puts "Installing ruby gem '#{g}."
  system 'gem', 'install', g
  unless $CHILD_STATUS.success?
    raise "Installing ruby gem '#{g}' failed."
  end
end

linux_packages = YAML.load_file(File.join(__dir__, 'linux.yaml'))

linux_packages['apt'].each do |pkg|
  puts "Installing apt package '#{pkg}'."
  system 'sudo', 'apt', 'install', pkg, '-y'
  unless $CHILD_STATUS.success?
    raise "Installing apt package '#{pkg}' failed."
  end
end

linux_packages['brew'].each do |f|
  puts "Installing brew formulae '#{f}'."
  system 'brew', 'install', f
  unless $CHILD_STATUS.success?
    raise "Installing brew formulae '#{f}' failed."
  end
end

linux_packages['snap'].each do |s|
  puts "Installing snap '#{s}'."
  system *['sudo', 'snap', 'install'].push(*s.split)
  unless $CHILD_STATUS.success?
    raise "Installing snap '#{s}' failed."
  end
end