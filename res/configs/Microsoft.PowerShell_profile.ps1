Import-Module Get-ChildItemColor
Import-Module -Name z
Import-Module PSWriteColor

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

# Remove 'diff' alias
Remove-Alias diff -Force

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

# helper function to show unicode character
Function U {
  param ([int] $Code)

  if ((0 -le $Code) -and ($Code -le 0xFFFF)) {
      return [char] $Code
  }

  if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF)) {
      return [char]::ConvertFromUtf32($Code)
  }

  throw "Invalid character code $Code"
}

Import-Module -Name posh-git
Import-Module -Name oh-my-posh

# default the prompt to agnoster oh-my-posh theme
Set-Theme agnoster