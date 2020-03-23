# Extension of default powershell profile.
# Only used for my main terminal.

# run default script
& ($PSScriptRoot + '\Microsoft.PowerShell_profile.ps1')

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