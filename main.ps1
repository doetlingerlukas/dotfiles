#Requires -RunAsAdministrator

# Add powershell-package provider
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# Install powershell modules
Install-Module psake -Force
Install-Module powershell-yaml -Force
Install-Module PSWriteColor -Force

Import-Module psake
Import-Module powershell-yaml
Import-Module PSWriteColor

Invoke-psake
