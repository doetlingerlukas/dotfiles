Import-Module -DisableNameChecking $PSScriptRoot\..\"file-helpers.psm1"

Task terminal {
  Write-Host 'Configuring terminal ...'

  $icon_dir = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState"
  $config_dir = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

  EnsurePath $icon_dir
  EnsurePath $config_dir

  Copy-Item $PSScriptRoot\..\..\"res\configs\settings.json" -Destination $config_dir

  Write-Host 'Successfully configured terminal!'
}