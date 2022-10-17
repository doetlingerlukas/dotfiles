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
  # Assert that task is run with evelated privileges
  Assert([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544') "evelated privileges are required"

  try {
    Get-Command "scoop" | Out-Null
    scoop update
  } catch {
    Write-Color -Text "Installing Scoop ..." -Color Green
    Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
  }

  # Parse YAML files
  $winget = parseYaml('winget.yaml')
  $scoop = parseYaml('scoop.yaml')

  Write-Color -Text "Installing programs ..." -Color Green

  # Install required winget packages
  foreach ($p in $winget.packages) {
    winget install -e --id $p --accept-source-agreements --accept-package-agreements
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

  Write-Color -Text "Installing additional Windows features ..." -Color Green

  try {
    # Windows Sandbox
    Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart

    # Required for WSL 2
    Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -All -Online -NoRestart

    if (IsProEdition) {
      Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -All -Online -NoRestart
    }
  }
  catch {
    if (!$env:CI) {
      Write-Error "Failed to install optional features!"
      exit
    }
  }

  Write-Color -Text "Installs done!" -Color Green


  Write-Color -Text "Unpinning start menu tiles and taskbar icons ..." -Color Green

  # Unpin start menu tiles
  $key = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*start.tilegrid`$windows.data.curatedtilecollection.tilecollection\Current"
  $data = $key.Data[0..25] + ([byte[]](202,50,0,226,44,1,1,0,0))
  Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $data
  Stop-Process -Name "ShellExperienceHost" -Force -ErrorAction SilentlyContinue

  # Unpin taskbar icons
  Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites" -Type Binary -Value ([byte[]](255))
  Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "FavoritesResolve" -ErrorAction SilentlyContinue
}


Task uninstalls {
  Write-Color "Uninstalling default apps ..."

  $default_apps = parseYaml('default-apps.yaml')

  uninstallApps($default_apps.microsoft)
  uninstallApps($default_apps.thirdparty)

  if (IsWindows11) {
    uninstallApps($default_apps.win11)
  }

  Write-Color "Uninstalls done!"
}
