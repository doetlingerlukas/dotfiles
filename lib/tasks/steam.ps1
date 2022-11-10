Import-Module -DisableNameChecking $PSScriptRoot\..\'registry.psm1'

Task steam {
  Write-Host 'Configuring Steam client ...'

  $path_steam = 'HKCU:\Software\Valve\Steam'
  Set-RegValue -Path $path_steam -Name 'Language' -Value 'english'
  Set-RegValue -Path "$path_steam\steamglobal" -Name 'Language' -Value 'english'

  # Don't start Steam with Windows.
  Remove-RegValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Steam'

  Write-Host 'Successfully configured Steam client!'
}