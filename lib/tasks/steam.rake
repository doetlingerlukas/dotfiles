# frozen_string_literal: true

require 'command'
require 'os'
require 'vdf'

desc 'configure Steam client'
task :steam do
  next unless OS.windows?

  puts 'Configuring Steam client ...'

  reg_key = 'HKCU:\Software\Valve\Steam'

  pwsh 'Set-ItemProperty', reg_key, 'Language', 'english'
  pwsh 'Set-ItemProperty', "#{reg_key}\\steamglobal", 'Language', 'english'

  # Don't start Steam with Windows.
  begin
    capture_pwsh 'Remove-ItemProperty', 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run', 'Steam'
  rescue RuntimeError => e
    puts 'Steam was not previously configured with autostart!'
  end


  path = 'C:/Program Files (x86)/Steam/userdata/136275020/config/localconfig.vdf'
  FileUtils.mkdir_p File.dirname(path)
  FileUtils.touch path

  vdf = VDF.parse(File.read(path))

  vdf['UserLocalConfigStore'] ||= {}
  vdf['UserLocalConfigStore']['News'] ||= {}

  # Disable Steam news pop-up.
  vdf['UserLocalConfigStore']['News']['NotifyAvailableGames'] = 0

  # Remember state of Steam Friends window.
  vdf['UserLocalConfigStore']['StartupState.Friends'] = 1

  File.write path, VDF.generate(vdf)

end