Task nvm {
  Write-Host 'Configuring nvm ... '

  nvm install lts
  nvm install '14.20.1'

  nvm use lts

  Write-Host 'nvm setup successfully!'
}