Import-Module -DisableNameChecking $PSScriptRoot\..\'system-info.psm1'

Task ssh {
  Assert-ElevatedPrivileges

  Write-Host 'Configuring ssh client ...'

  Exec { Set-Service ssh-agent -StartupType Automatic }

  $ssh_dir = "$env:USERPROFILE\OneDrive\.ssh"
  if (Test-Path $ssh_dir) {
    Copy-Item "$ssh_dir\*" -Destination "$env:USERPROFILE\.ssh" -Recurse
  }

  $ssh_config | Out-File -FilePath "$env:USERPROFILE\.ssh\config"

  # Use OpenSSH as agent for Git
  $openssh_path = (Get-Command ssh).Path
  [Environment]::SetEnvironmentVariable('GIT_SSH', $openssh_path, [System.EnvironmentVariableTarget]::User)

  Write-Host 'Successfully setup ssh client!'
}

$ssh_config = @"
Host github.com
  HostName github.com
  IdentityFile ~/.ssh/github_ed25519
"@