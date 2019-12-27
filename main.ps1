param(
  [string]$mode="setup"
)

Function executeConfigs {
  Get-ChildItem -Filter '*.rake' '.\lib\tasks\' | ForEach-Object {
    rake $_.FullName
  }
}

Function verifyRubyInstallation {
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

Function verifyRakeInstallation {
  try {
    $rake = rake --version
    if ($rake.StartsWith("rake, version")) {
      Write-Host "Rake is installed and available."
    } else {
      gem install rake
    }
  } catch {
    Write-Error "Ruby is not available on this system. Exiting now!"
    exit
  }
}

# Add powershell-package provider
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install YAML module
Install-Module powershell-yaml -Force
Import-Module powershell-yaml

switch ($mode) {
  "config" {
    verifyRubyInstallation
    verifyRakeInstallation
    executeConfigs
    break
  }
  "setup" {
    & .\installs.ps1
    verifyRubyInstallation
    verifyRakeInstallation
    executeConfigs
    break
  }
}

"Restarting in 30 seconds ..."
Start-Sleep 30
Restart-Computer