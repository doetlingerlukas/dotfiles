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

  desc 'windows privacy settings'
  task :privacy do
    next unless OS.windows?

    puts 'Configuring Windows privacy settings ...'

    # Disable activity history.
    begin
      Win32::Registry::HKEY_LOCAL_MACHINE.open('Software\Policies\Microsoft\Windows\System', desired = Win32::Registry::KEY_ALL_ACCESS) do |reg|
        reg['EnableActivityFeed', Win32::Registry::REG_DWORD] = 0
        reg['PublishUserActivities', Win32::Registry::REG_DWORD] = 0
        reg['UploadUserActivities', Win32::Registry::REG_DWORD] = 0
      end
    rescue Win32::Registry::Error
      puts 'Disabling activity history failed!'
    end

    # Disable location tracking.
    begin
      Win32::Registry::HKEY_LOCAL_MACHINE.create('Software\Policies\Microsoft\Windows\LocationAndSensors') do |reg|
        reg['DisableLocation', Win32::Registry::REG_DWORD] = 1
        reg['DisableLocationScripting', Win32::Registry::REG_DWORD] = 1
      end
    rescue Win32::Registry::Error
      puts 'Disabling location tracking failed!'
    end

    # Disable feedback.
    Win32::Registry::HKEY_CURRENT_USER.create('Software\Microsoft\Siuf\Rules') do |reg|
      reg['NumberOfSIUFInPeriod', Win32::Registry::REG_DWORD] = 0
    end

    begin
      Win32::Registry::HKEY_LOCAL_MACHINE.create('Software\Policies\Microsoft\Windows\DataCollection') do |reg|
        reg['DoNotShowFeedbackNotifications', Win32::Registry::REG_DWORD] = 1
      end
    rescue Win32::Registry::Error
      puts 'Disabling feedback notifications failed!'
    end

    capture_pwsh 'Disable-ScheduledTask' '-TaskName' 'Microsoft\Windows\Feedback\Siuf\DmClient' '-ErrorAction' 'SilentlyContinue'
    capture_pwsh 'Disable-ScheduledTask' '-TaskName' 'Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload' '-ErrorAction' 'SilentlyContinue'

    # Disable tailored experience.
    Win32::Registry::HKEY_CURRENT_USER.create('Software\Policies\Microsoft\Windows\CloudContent') do |reg|
      reg['DisableTailoredExperiencesWithDiagnosticData', Win32::Registry::REG_DWORD] = 1
    end

    # Disable advertising ID.
    begin
      Win32::Registry::HKEY_LOCAL_MACHINE.create('Software\Policies\Microsoft\Windows\AdvertisingInfo') do |reg|
        reg['DisabledByGroupPolicy', Win32::Registry::REG_DWORD] = 1
      end
    rescue Win32::Registry::Error
      puts 'Disabling advertising ID failed!'
    end

    # Disable error reporting.
    begin
      Win32::Registry::HKEY_LOCAL_MACHINE.open('Software\Microsoft\Windows\Windows Error Reporting', desired = Win32::Registry::KEY_ALL_ACCESS) do |reg|
        reg['Disabled', Win32::Registry::REG_DWORD] = 1
      end
    rescue Win32::Registry::Error
      puts 'Disabling error reporting failed!'
    end

    capture_pwsh 'Disable-ScheduledTask' '-TaskName' 'Microsoft\Windows\Windows Error Reporting\QueueReporting' '-ErrorAction' 'SilentlyContinue'

    # Disable diagnostics tracking service.
    capture_pwsh 'Stop-Service' 'DiagTrack' '-WarningAction SilentlyContinue'
    capture_pwsh 'Set-Service ' 'DiagTrack' '-StartupType Disabled'

  end
end