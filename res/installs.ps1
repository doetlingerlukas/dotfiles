#Requires -RunAsAdministrator

Function parseYaml {
  Param([string]$file)

  [string[]]$fileContent = Get-Content ($PSScriptRoot + "\" + $file)
  $content = ''
  foreach ($line in $fileContent) {
    $content = $content + "`n" + $line
  }
  return ConvertFrom-YAML $content
}

Function installChocoPackages {
  Param([String[]]$packages)

  foreach ($p in $packages) {
    choco install $p -y
  }
}

Function uninstallApps {
  Param([String[]]$apps)

  foreach ($a in $apps) {
    Get-AppxPackage "$a" -AllUsers | Remove-AppxPackage
    Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "$a" | Remove-AppxProvisionedPackage -Online
  }  
}

if ($false -eq $(Test-Path -Path "$env:ProgramData\Chocolatey")) {
  Write-Color -Text "Installing Chocolatey ..." -Color Green
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

try {
  Get-Command "scoop" | Out-Null
} catch {
  Write-Color -Text "Installing Scoop ..." -Color Green
  Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

# Parse YAML files.
$choco = parseYaml('choco.yaml')
$scoop = parseYaml('scoop.yaml')
$gems = parseYaml('gems.yaml')

Write-Color -Text "Installing programs ..." -Color Green

# Install required choco packages.
installChocoPackages($choco.required)

# Install scoop buckets and packages.
foreach ($b in $scoop.buckets) {
  scoop bucket add $b
}
foreach ($p in $scoop.packages) {
  scoop install $p
}

# Install common choco packages.
installChocoPackages($choco.common)

# Install system specific choco packages.
if ($env:COMPUTERNAME.ToLower().contains("razer")) {
  installChocoPackages($choco.laptop)
} elseif ($env:COMPUTERNAME.ToLower().contains("pc")) {
  installChocoPackages($choco.desktop)
}

Write-Color -Text "Updating PATH ..." -Color Green
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Color -Text "Installing ruby gems ..." -Color Green
foreach ($g in $gems.gems) {
  gem install $g
}

Write-Color -Text "Installing additional Windows features ..." -Color Green

try {
  # Windows Sandbox
  Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart

  # Required for WSL 2
  Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -All -Online -NoRestart

  Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -All -Online -NoRestart
}
catch {
  if (!$env:CI) {
    Write-Error "Failed to install optional features!"
    exit
  }
}

Write-Color -Text "Installs done!" -Color Green


Write-Color -Text "Unpinning start menu tiles and taskbar icons ..." -Color Green

# Unpin start menu tiles.
$key = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*start.tilegrid`$windows.data.curatedtilecollection.tilecollection\Current"
$data = $key.Data[0..25] + ([byte[]](202,50,0,226,44,1,1,0,0))
Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $data
Stop-Process -Name "ShellExperienceHost" -Force -ErrorAction SilentlyContinue

# Unpin taskbar icons.
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites" -Type Binary -Value ([byte[]](255))
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "FavoritesResolve" -ErrorAction SilentlyContinue


Write-Color -Text "Uninstalling default apps ..." -Color Green

$default_apps = parseYaml('default-apps.yaml')

uninstallApps($default_apps.microsoft)
uninstallApps($default_apps.thirdparty)

Write-Color -Text "Uninstalls done!" -Color Green