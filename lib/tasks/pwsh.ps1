Task pwsh {
  Write-Host 'Setting up pwsh ...'

  # Install modules
  Exec { pwsh -command { Install-Module z -Scope CurrentUser -Force } }
  Exec { pwsh -command { Install-Module PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck } }
  Exec { pwsh -command { Install-Module Get-ChildItemColor -Scope CurrentUser -Force -AllowClobber } }
  Exec { pwsh -command { Install-Module PSWriteColor -Scope CurrentUser -Force } }

  # Copy configs to folders
  $config_dir = "$env:USERPROFILE\Documents\PowerShell"

  if (!Test-Path $config_dir) { New-Item -Path $config_dir -ItemType Directory }

  Copy-Item $PSScriptRoot\..\..\"res\configs\Microsoft.PowerShell_profile.ps1" -Destination $config_dir
  Copy-Item $PSScriptRoot\..\..\"res\configs\posh-theme.omp.json" -Destination $config_dir

  Write-Hoste 'Successfully setup pwsh!'
}