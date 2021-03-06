# frozen_string_literal: true

require 'os'

task :battlefield5 do
  next unless OS.windows?

  puts 'Setting up Battlefiled V config ...'

  config_dir = 'C:/Program Files (x86)/Origin Games/Battlefield V'

  FileUtils.mkdir_p config_dir

  File.write "#{config_dir}/user.cfg",  <<~CFG
    // fps counter
    PerfOverlay.DrawFps 1
  CFG

  puts 'Battlefield V config setup successfully!'
end