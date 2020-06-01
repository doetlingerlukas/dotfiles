# frozen_string_literal: true

require 'os'
require 'command'
require 'laptop'
require 'win32/registry' if OS.windows?

task :windows => [:'windows:energy', :'windows:ui', :'windows:cortana']

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
    begin
      Win32::Registry::HKEY_LOCAL_MACHINE.create('Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation') do |reg|
        reg['DisableStartupSound', Win32::Registry::REG_DWORD] = 1
      end
    rescue Win32::Registry::Error
      puts 'Disabling startup sound failed!'
    end
  end

  desc 'disable cortana'
  task :cortana do
    next unless OS.windows?

    puts 'Disabling Cortana ...'
    
    Win32::Registry::HKEY_CURRENT_USER.create('Software\Microsoft\Personalization\Settings') do |reg|
      reg['AcceptedPrivacyPolicy', Win32::Registry::REG_DWORD] = 0
    end

    Win32::Registry::HKEY_CURRENT_USER.create('Software\Microsoft\InputPersonalization') do |reg|
      reg['RestrictImplicitTextCollection', Win32::Registry::REG_DWORD] = 1
      reg['RestrictImplicitInkCollection', Win32::Registry::REG_DWORD] = 1

      reg.create('TrainedDataStore') do |inner|
        inner['HarvestContacts', Win32::Registry::REG_DWORD] = 0
      end
    end

    begin
      Win32::Registry::HKEY_LOCAL_MACHINE.create('Software\Microsoft\PolicyManager\default\Experience\AllowCortana') do |reg|
        reg['Value', Win32::Registry::REG_DWORD] = 0
      end

      Win32::Registry::HKEY_LOCAL_MACHINE.create('Software\Policies\Microsoft\Windows\Windows Search') do |reg|
        reg['AllowCortana', Win32::Registry::REG_DWORD] = 0
      end
      
      Win32::Registry::HKEY_LOCAL_MACHINE.create('Software\Policies\Microsoft\InputPersonalization') do |reg|
        reg['AllowInputPersonalization', Win32::Registry::REG_DWORD] = 0
      end
    rescue Win32::Registry::Error
      puts 'Disabling Cortana failed!'
    end
  end
end