# frozen_string_literal: true

require 'os'
require 'command'
require 'distro'

desc 'Configure ubuntu.'
task :ubuntu do
  next unless OS.linux? && ubuntu? && !wsl

  puts 'Configuring ubuntu.'

  # enable fractional scaling
  command 'gsettings', 'set', 'org.gnome.mutter', 'experimental-features', "['x11-randr-fractional-scaling']"

  puts 'Installing themes.'
  command 'sudo', 'add-apt-repository', 'ppa:tista/adapta', '-y'
  command 'sudo', 'add-apt-repository', 'ppa:papirus/papirus', '-y'
  command 'sudo', 'apt', 'update', '-y'

  command 'sudo', 'apt', 'install', 'arc-theme', '-y'
  command 'sudo', 'apt', 'install', 'adapta-gtk-theme', '-y'
  command 'sudo', 'apt', 'install', 'papirus-icon-theme', '-y'

end