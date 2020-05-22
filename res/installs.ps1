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

# parse YAML files
$choco = parseYaml('choco.yaml')
$scoop = parseYaml('scoop.yaml')
$gems = parseYaml('gems.yaml')

Write-Color -Text "Installing programs ..." -Color Green

# install required choco packages
installChocoPackages($choco.required)

# install scoop buckets and packages
foreach ($b in $scoop.buckets) {
  scoop bucket add $b
}
foreach ($p in $scoop.packages) {
  scoop install $p
}

# install common choco packages
installChocoPackages($choco.common)

# install system specific choco packages
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

# Windows Sandbox
Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart

Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -All -Online -NoRestart

Write-Color -Text "Installs done!" -Color Green