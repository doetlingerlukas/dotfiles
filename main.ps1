param(
  [string]$mode="setup"
)

Function executeConfigs {
  Get-ChildItem -Filter '*.rake' '.\lib\tasks\' | ForEach-Object {
    rake $_.BaseName
  }
}

Function verifyInstall {
  Param([String]$name)
  try {
    Get-Command name | Out-Null
  } catch {
    Write-Error "'$name' is not available. Exiting now!"
    exit
  }
}

switch ($mode) {
  "config" {
    foreach ($p in "scoop", "choco", "ruby", "rake") {
      verifyInstall($p)
    }
    break
  }
  "setup" {
    # Add powershell-package provider
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

    # Install powershell modules
    Install-Module powershell-yaml -Force
    Install-Module PSWriteColor -Force

    Import-Module powershell-yaml
    Import-Module PSWriteColor

    & .\res\installs.ps1
    break
  }
}

& .\res\windows.ps1
executeConfigs