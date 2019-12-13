param(
  [string]$mode="setup"
)

Function executeConfigs {
  Get-ChildItem -Filter '*.ps1' '.\configs\' | ForEach-Object {
    & $_.FullName
  }
}

Function validateRubyInstallation {
  try {
    $ruby = ruby -v
    if ($ruby.StartsWith("ruby 2")) {
      Write-Host "Ruby is installed and available."
    }
  } catch {
    $Env:Path += ";C:\tools\ruby26\bin"
    refreshenv | Out-Null

    try {
      $ruby = ruby -v
      if ($ruby.StartsWith("ruby 2")) {
        Write-Host "Ruby has been added to the PATH."
      }
    } catch {
      Write-Error "Ruby is not available on this system. Exiting now!"
      exit
    }
  }
}

# Add powershell-package provider
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install YAML module
Install-Module powershell-yaml -Force
Import-Module powershell-yaml

switch ($mode) {
  "config" {
    validateRubyInstallation
    executeConfigs
    break
  }
  "setup" {
    & .\installs.ps1
    validateRubyInstallation
    executeConfigs
    break
  }
}

"Restarting in 30 seconds ..."
Start-Sleep 30
Restart-Computer