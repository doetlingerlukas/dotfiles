# frozen_string_literal: true

require 'os'
require 'command'
require 'distro'

desc 'Configure elementary os.'
task :elementary do
  next unless OS.linux? && elementary?

  puts 'Configuring elementary os.'

  # configure files
  command 'gsettings', 'set', 'org.pantheon.files.preferences', 'show-hiddenfiles', 'true'
  command 'gsettings', 'set', 'io.elementary.files.preferences', 'single-click', 'false'

  # minimize window on right-click
  command 'gsettings', 'set', 'org.gnome.desktop.wm.preferences', 'action-right-click-titlebar', 'minimize'
end