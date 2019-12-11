# Add package provider
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install YAML module
Install-Module powershell-yaml -Force
Import-Module powershell-yaml

[string[]]$fileContent = Get-Content '.\choco.yaml'
$content = ''
foreach ($line in $fileContent) { $content = $content + "`n" + $line }
$choco = ConvertFrom-YAML $content

foreach ($program in $choco.common) {
  Write-Host $program
}