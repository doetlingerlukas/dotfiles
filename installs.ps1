function installChocoPackages {
  Param([String[]]$packages)

  foreach ($p in $packages) {
    choco install $p -y
  }
}

# Add powershell-package provider
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install YAML module
Install-Module powershell-yaml -Force
Import-Module powershell-yaml

[string[]]$fileContent = Get-Content '.\choco.yaml'
$content = ''
foreach ($line in $fileContent) { $content = $content + "`n" + $line }
$choco = ConvertFrom-YAML $content

# install common programs
installChocoPackages($choco.common)

# install system specific programs
if ($env:COMPUTERNAME.ToLower().contains("razer")) {
  installChocoPackages($choco.laptop)
} else {
  installChocoPackages($choco.desktop)
}