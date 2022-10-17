Task terminal {
  Write-Host 'Configuring terminal ...'

  $icon_dir = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState"
  $config_dir = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

  if (!Test-Path $config_dir) { New-Item -Path $config_dir -ItemType Directory }

  Copy-Item $PSScriptRoot\..\..\"res\configs\settings.json" -Destination $config_dir

  Write-Host 'Successfully configured terminal!'
}