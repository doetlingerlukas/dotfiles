Function installChocoPackages {
  Param([String[]]$packages)

  foreach ($p in $packages) {
    choco install $p -y
  }
}

if ($false -eq $(Test-Path -Path "$env:ProgramData\Chocolatey")) {
  "Installing chocolatey package manager ..."
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}


[string[]]$fileContent = Get-Content ($PSScriptRoot + '\choco.yaml')
$content = ''
foreach ($line in $fileContent) { $content = $content + "`n" + $line }
$choco = ConvertFrom-YAML $content

# install common programs
installChocoPackages($choco.common)

# install system specific programs
if ($env:COMPUTERNAME.ToLower().contains("razer")) {
  installChocoPackages($choco.laptop)
} elseif ($env:COMPUTERNAME.ToLower().contains("pc")) {
  installChocoPackages($choco.desktop)
}

"Updating PATH ..."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

"Installing Powerline Fonts ..."
git clone 'https://github.com/powerline/fonts.git'
& .\fonts\install.ps1
Remove-Item -LiteralPath "fonts" -Force -Recurse