Task gpg -Depends git {
  Write-Host "Setting up GPG config ..."

  Exec { gpg --version } "Error, GPG is not available."

  $gpg_binary = (Get-Command gpg).Path

  $ssh_dir = "$env:USERPROFILE\OneDrive\.gpg"
  if (Test-Path $ssh_dir) {
    Copy-Item "$ssh_dir\*" -Destination "$env:USERPROFILE\.gpg" -Recurse
  }

  git config --global --unset gpg.format
  git config --global gpg.program $gpg_binary

  git config --global commit.gpgsign true

  Write-Host "Don't forget to import your GPG keys and set the ID for git to use:"
  Write-Host "git config --global user.signingkey <ID>"
}
