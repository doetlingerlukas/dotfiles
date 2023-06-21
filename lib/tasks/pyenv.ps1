Task pyenv {
  Write-Host "Setting up pyenv ..."

  Exec { pyenv } "Error, pyenv is not available."

  pyenv install '2.7.18'
  pyenv install '3.10.5'

  pyenv global '3.10.5'

  Write-Host "Successfully set up pyenv!"
}
