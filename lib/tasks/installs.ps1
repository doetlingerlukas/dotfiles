Import-Module -DisableNameChecking $PSScriptRoot\..\"system-info.psm1"

Function parseYaml {
  Param([string]$file)

  [string[]]$fileContent = Get-Content ($PSScriptRoot + "\..\..\res\" + $file)
  $content = ''
  foreach ($line in $fileContent) {
    $content = $content + "`n" + $line
  }
  return ConvertFrom-YAML $content
}

Function uninstallApps {
  Param([String[]]$apps)

  foreach ($a in $apps) {
    if ((Get-AppxPackage -AllUsers -Name $a) -or (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $a)) {
      Write-Host "Trying to remove $a ..."
      Get-AppxPackage "$a" -AllUsers | Remove-AppxPackage
      Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "$a" | Remove-AppxProvisionedPackage -Online -AllUsers
    } else {
      Write-Host "$a was already removed or not found."
    }
  }
}

Task installs {
  Assert-ElevatedPrivileges

  try {
    Get-Command 'scoop' | Out-Null
    scoop update

    # Remove old installation files.
    scoop cleanup *
  } catch {
    $msg = 'Scoop should not be installed with elevated privileges. File permissions will have to be changed afterwards for scoop to run correctly. Proceed anyway? [Y/N]'
    $response = Read-Host -Prompt $msg

    if ($response -eq 'n') {
      Write-Host 'Please install scoop without elevated privileges first. (See https://scoop.sh/)'
      return
    }

    Write-Host 'Installing Scoop ...'
    Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
  }

  # Parse YAML files
  $winget = parseYaml('winget.yaml')
  $scoop = parseYaml('scoop.yaml')

  Write-Host 'Installing programs ...'

  # Install required winget packages
  foreach ($p in $winget.packages) {
    try {
      Exec { winget list -e --id $p | Out-Null }

      Write-Host "$p is already installed. Trying to upgrade ..."
      winget upgrade -e --id $p
    }
    catch {
      # App was not found and will be installed.
      winget install -e --id $p --accept-source-agreements --accept-package-agreements
    }
  }

  # Essentials are required to add buckets
  foreach ($e in $scoop.essentials) {
    scoop install $e
  }
  # Install scoop buckets and packages
  foreach ($b in $scoop.buckets) {
    scoop bucket add $b
  }
  foreach ($p in $scoop.packages) {
    scoop install $p
  }

  Write-Host 'Installing additional Windows features ...'

  try {
    # Windows Sandbox
    Enable-WindowsOptionalFeature -FeatureName 'Containers-DisposableClientVM' -All -Online -NoRestart

    # Required for WSL 2
    Enable-WindowsOptionalFeature -FeatureName 'VirtualMachinePlatform' -All -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName 'Microsoft-Windows-Subsystem-Linux' -All -Online -NoRestart

    wsl --set-default-version 2

    if (IsProEdition) {
      Enable-WindowsOptionalFeature -FeatureName 'Microsoft-Hyper-V' -All -Online -NoRestart
    }
  }
  catch {
    if (!$env:CI) {
      Write-Error 'Failed to install optional features!'
      exit
    }
  }

  Write-Host 'Installs done!'
}


Task uninstalls {
  Assert-ElevatedPrivileges

  Write-Host 'Uninstalling default apps ...'

  $default_apps = parseYaml('default-apps.yaml')

  uninstallApps($default_apps.microsoft)
  uninstallApps($default_apps.thirdparty)

  if (IsWindows11) {
    uninstallApps($default_apps.win11)
  }

  Write-Host 'Uninstalls done!'
}
