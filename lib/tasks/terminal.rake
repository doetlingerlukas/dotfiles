# frozen_string_literal: true

require 'os'
require 'command'

desc 'Configure windows terminal.'
task :terminal do
  next unless OS.windows?

  puts "Configuring Microsoft Windows Terminal ..."

  config_dir = "#{ENV['LocalAppData']}/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"

  FileUtils.mkdir_p config_dir
  FileUtils.cp("#{__dir__}/../../res/configs/settings.json", config_dir)
end