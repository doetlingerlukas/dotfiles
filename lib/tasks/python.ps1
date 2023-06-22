Task python {
  Write-Host "Setting up python environment ..."

  Exec { python } "Error, python is not available."

  pip install --upgrade pip
  pip install pipenv
  pip install notebook

  Write-Host "Successfully set up python environment!"
}
