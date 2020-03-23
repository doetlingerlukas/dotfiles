Import-Module Get-ChildItemColor
Import-Module -Name z

# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# Set default user for oh-my-posh theme
$DefaultUser = $env:UserName

# Helper function to change directory to development workspace
Function cdw { Set-Location "C:\Users\$DefaultUser\Documents\Git" }

# Helper function to set location to the User Profile directory
Function cuserprofile { Set-Location ~ }
Set-Alias ~ cuserprofile -Option AllScope

Function createFile {
  param ([string]$file)

  if ($file -eq $null) {
    throw "No filename supplied"
  }

  if (Test-Path $file) {
    (Get-ChildItem $file).LastWriteTime = Get-Date
  }
  else {
    Write-Output $null > $file
  }
}
  
Set-Alias touch createFile
New-Alias which get-command