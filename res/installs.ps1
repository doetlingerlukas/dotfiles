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
  "Installing Chocolatey ..."
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

"Installing Scoop ..."
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

# parse YAML files
$choco = parseYaml('choco.yaml')
$scoop = parseYaml('scoop.yaml')

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

"Updating PATH ..."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")