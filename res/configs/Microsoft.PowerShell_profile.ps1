Import-Module Get-ChildItemColor
Import-Module z
Import-Module PSWriteColor

# Setup oh-my-posh
oh-my-posh --init --shell pwsh --config "$env:USERPROFILE\Documents\PowerShell\posh-theme.omp.json" | Invoke-Expression

# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# Remove 'diff' alias
Remove-Alias diff -Force

New-Alias which get-command

# Helper function to change directory to development workspace
Function cdw { Set-Location "$env:USERPROFILE\Git" }

# Helper function to set location to the User Profile directory
Function cuserprofile { Set-Location ~ }
Set-Alias ~ cuserprofile -Option AllScope

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
