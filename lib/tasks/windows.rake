# frozen_string_literal: true

require 'os'
require 'command'
require 'laptop'
require 'win32/registry' if OS.windows?

task :windows => [:'windows:energy', :'windows:ui']

namespace :windows do
  desc 'configure windows power settings'
  task :energy do
    next unless OS.windows?

    puts 'Disabling screen timeout and standby mode.'

    command 'powercfg', '-change', '-monitor-timeout-ac', '0'
    command 'powercfg', '-change', '-monitor-timeout-dc', '0'
    command 'powercfg', '-change', '-standby-timeout-ac', '0'
    command 'powercfg', '-change', '-standby-timeout-ac', '0'
  end

  desc 'configure windows ui'
  task :ui do
    next unless OS.windows?

    puts 'Configuring Windows UI ...'

    # Hide people icon at taskbar.
    Win32::Registry::HKEY_CURRENT_USER.create('Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People') do |reg|
      reg['PeopleBand', Win32::Registry::REG_DWORD] = 0
    end

    # Show search icon in taskbar.
    Win32::Registry::HKEY_CURRENT_USER.create('Software\Microsoft\Windows\CurrentVersion\Search') do |reg|
      reg['SearchboxTaskbarMode', Win32::Registry::REG_DWORD] = 1
    end

    # Disable startup sound.
    Win32::Registry::HKEY_LOCAL_MACHINE.create('Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation') do |reg|
      reg['DisableStartupSound', Win32::Registry::REG_DWORD] = 1
    end
  end
end