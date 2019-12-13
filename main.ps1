param(
  [string]$mode="setup"
)

Function executeConfigs () {
  Get-ChildItem -Filter '*.ps1' '.\configs\' | ForEach-Object {
    & $_.FullName
  }
}

# Add powershell-package provider
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install YAML module
Install-Module powershell-yaml -Force
Import-Module powershell-yaml

switch ($mode) {
  "config" {
    Invoke-Expression executeConfigs
    break
  }
  "setup" {
    & .\programs.ps1
    Invoke-Expression executeConfigs
    break
  }
}

"Restarting in 30 seconds ..."
Start-Sleep 30
Restart-Computer