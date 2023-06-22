Import-Module -DisableNameChecking $PSScriptRoot\..\"system-info.psm1"

Task python {
  Assert-ElevatedPrivileges

  Write-Host "Setting up python environment ..."

  Remove-Item -Force "$env:UserProfile\AppData\Local\Microsoft\WindowsApps\python*"

  Exec { regedit /s "$env:UserProfile\scoop\apps\python\current\install-pep-514.reg" }

  Exec { python --version } "Error, python is not available."

  pip install --upgrade pip
  pip install pipenv
  pip install notebook
  pip install pyenv-win --target "$env:UserProfile\\.pyenv"

  [System.Environment]::SetEnvironmentVariable('PYENV', "$env:UserProfile\.pyenv\pyenv-win\", 'User')
  [System.Environment]::SetEnvironmentVariable('PYENV_ROOT', "$env:UserProfile\.pyenv\pyenv-win\", 'User')
  [System.Environment]::SetEnvironmentVariable('PYENV_HOME', "$env:UserProfile\.pyenv\pyenv-win\", 'User')

  $new_path = "$env:UserProfile\.pyenv\pyenv-win\bin;" + "$env:UserProfile\.pyenv\pyenv-win\shims;" + [System.Environment]::GetEnvironmentVariable('path', 'User')
  [System.Environment]::SetEnvironmentVariable('path', $new_path, 'User')

  Write-Host "Successfully set up python environment!"
}
