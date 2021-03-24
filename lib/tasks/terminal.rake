# frozen_string_literal: true

require 'os'
require 'command'
require 'down'

desc 'Configure windows terminal.'
task :terminal do
  next unless OS.windows?

  puts "Configuring Microsoft Windows Terminal ..."

  icon_dir = "#{ENV['LocalAppData']}/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/RoamingState"

  {
    'https://assets.ubuntu.com/v1/29985a98-ubuntu-logo32.png' => 'ubuntu.png'
  }.each do |link, name|
    Down.download(link, destination: "#{icon_dir}/#{name}")
  end

  config_dir = "#{ENV['LocalAppData']}/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"

  FileUtils.mkdir_p config_dir
  FileUtils.cp("#{__dir__}/../../res/configs/settings.json", config_dir)
end