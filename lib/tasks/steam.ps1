Import-Module -DisableNameChecking $PSScriptRoot\..\'registry.psm1'

Task steam {
  Write-Host 'Configuring Steam client ...'

  $path_steam = 'HKCU:\Software\Valve\Steam'
  Set-RegValue -Path $path_steam -Name 'Language' -Value 'english'
  Set-RegValue -Path "$path_steam\steamglobal" -Name 'Language' -Value 'english'

  # Don't start Steam with Windows.
  Remove-RegValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Steam'

  # Download required PowerShell module.
  $remote_uri = 'https://raw.githubusercontent.com/doetlingerlukas/Steam-GetOnTop/master/Modules/SteamTools/SteamTools.psm1'
  $steam_module_path = "$env:USERPROFILE\Documents\PowerShell\Modules\SteamTools.psm1"
  Invoke-WebRequest -Uri $remote_uri -OutFile $steam_module_path

  Import-Module -DisableNameChecking $steam_module_path

  $config = 'C:\Program Files (x86)\Steam\userdata\136275020\config\localconfig.vdf'
  $config_object = ConvertFrom-VDF -InputObject (Get-Content $config)

  # Remember state of Steam Friends window.
  $config_object.UserLocalConfigStore | Add-Member -MemberType NoteProperty -Name 'StartupState.Friends' -Value 1

  # Disable Steam news pop-up.
  $news_object = [PSCustomObject]@{NotifyAvailableGames = 0}
  $config_object.UserLocalConfigStore | Add-Member -MemberType NoteProperty -Name 'News' -Value $news_object

  ConvertTo-VDF -InputObject $config_object | Out-File $config

  Write-Host 'Successfully configured Steam client!'
}