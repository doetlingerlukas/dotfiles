Import-Module -DisableNameChecking $PSScriptRoot\..\"file-helpers.psm1"

Task gpg -Depends git {
  Write-Host "Setting up GPG config ..."

  Exec { gpg --version } "Error, GPG is not available."

  $gpg_binary = (Get-Command gpg).Path

  $gpg_dir = "$env:USERPROFILE\OneDrive\.gpg"
  if (Test-Path $gpg_dir) {
    Copy-Item "$gpg_dir\*" -Destination "$env:USERPROFILE\.gpg" -Recurse
  }

  git config --global --unset gpg.format
  git config --global gpg.program $gpg_binary

  git config --global commit.gpgsign true

  Write-Host "Don't forget to import your GPG keys and set the ID for git to use:"
  Write-Host "git config --global user.signingkey <ID>"

  $gpg_config_dir = "$env:USERPROFILE\AppData\Roaming\gnupg"
  EnsurePath $gpg_config_dir

  $gpg_agent_config | Out-File -FilePath "$gpg_config_dir\gpg-agent.conf"
}

$gpg_agent_config = @"
default-cache-ttl 34560000
max-cache-ttl 34560000
"@
