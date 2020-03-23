# frozen_string_literal: true

require 'os'
require 'command'

desc 'Configure powershell.'
task :powershell do
  next unless OS.windows?

  puts "Installing powershell modules ..."
  pwsh 'Install-Module', 'posh-git', '-Scope', 'CurrentUser', '-Force'
  pwsh 'Install-Module', 'oh-my-posh', '-Scope', 'CurrentUser', '-Force'
  pwsh 'Install-Module', '-Name', 'z', '-Scope', 'CurrentUser', '-Force'
  pwsh 'Install-Module', '-Name', 'PSReadLine', '-AllowPrerelease', '-Scope', 'CurrentUser', '-Force', '-SkipPublisherCheck'
  pwsh 'Install-Module', '-AllowClobber', 'Get-ChildItemColor'

  ps_config_dir = "C:/Users/#{ENV['USERNAME']}/Documents/PowerShell"

  FileUtils.mkdir_p ps_config_dir
  FileUtils.cp("#{__dir__}/../../res/configs/Microsoft.PowerShell_profile.ps1", ps_config_dir)
  FileUtils.cp("#{__dir__}/../../res/configs/profile_extension.ps1", ps_config_dir)
end