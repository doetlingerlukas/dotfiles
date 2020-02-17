param(
  [string]$mode="setup"
)

Function executeConfigs {
  Get-ChildItem -Filter '*.rake' '.\lib\tasks\' | ForEach-Object {
    rake $_.BaseName
  }
}

Function verifyRubyInstallation {
  try {
    $ruby = ruby -v
    if ($ruby.StartsWith("ruby")) {
      Write-Host "Ruby is installed and available."
    }
  } catch {
    if (!(Test-Path -Path 'C:\tools\**\bin\ruby.exe')) {
      choco install ruby -y
    }
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    try {
      $ruby = ruby -v
      if ($ruby.StartsWith("ruby")) {
        Write-Host "Ruby is available after updating PATH."
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

Function installGems {
  [string[]]$fileContent = Get-Content ($PSScriptRoot + '\res\gems.yaml')
  $content = ''
  foreach ($line in $fileContent) { $content = $content + "`n" + $line }
  $gems = ConvertFrom-YAML $content

  foreach ($g in $gems.gems) {
    try {
      gem install $g
    } catch {
      Write-Error "Failed installing gem $($g). Exiting now!"
      exit
    }
  }
}

Function verifyChocolateyInstallation {
  try {
    $choco = choco -v
    if (!$choco -match '[0-9.]') {
      Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
  } catch {
    "Installing chocolatey package manager ..."
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  }
}

switch ($mode) {
  "config" {
    verifyChocolateyInstallation
    break
  }
  "setup" {
    # Add powershell-package provider
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

    # Install YAML module
    Install-Module powershell-yaml -Force
    Import-Module powershell-yaml

    & .\res\installs.ps1
    break
  }
}

verifyRubyInstallation
verifyRakeInstallation
& .\res\windows.ps1
installGems
executeConfigs