# frozen_string_literal: true

require 'command'
require 'os'
require 'vdf'
require 'win32/registry' if OS.windows?

desc 'configure Steam client'
task :steam do
  next unless OS.windows?

  puts 'Configuring Steam client ...'

  Win32::Registry::HKEY_CURRENT_USER.create('Software\Valve\Steam') do |reg|
    reg['Language', Win32::Registry::REG_SZ] = 'english'

    reg.create('steamglobal') do |global|
      global['Language', Win32::Registry::REG_SZ] = 'english'
    end
  end

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