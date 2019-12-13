function installChocoPackages {
  Param([String[]]$packages)

  foreach ($p in $packages) {
    choco install $p -y
  }
}

"Installing chocolatey package manager ..."

if ($false -eq $(Test-Path -Path "$env:ProgramData\Chocolatey")) {
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}


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