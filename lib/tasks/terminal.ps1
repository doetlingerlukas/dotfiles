Import-Module -DisableNameChecking $PSScriptRoot\..\"file-helpers.psm1"

Task terminal {
  Write-Host 'Configuring terminal ...'

  $icon_dir = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState"
  $config_dir = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

  EnsurePath $icon_dir
  EnsurePath $config_dir

  Copy-Item $PSScriptRoot\..\..\"res\configs\settings.json" -Destination $config_dir

  @{
    'ubuntu' = 'https://assets.ubuntu.com/v1/49a1a858-favicon-32x32.png'
    'kali' = 'https://www.kali.org/images/favicon.png'
  }.GetEnumerator() | foreach {
    Write-Host $_.Value
    Invoke-WebRequest -Uri $_.Value -OutFile "$icon_dir\$($_.Name).png"
  }

  Write-Host 'Successfully configured terminal!'
}