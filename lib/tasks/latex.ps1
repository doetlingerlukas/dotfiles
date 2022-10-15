Task latex {
  Write-Host 'Settung up LaTeX environment ... '

  mpm --update
  mpm --install=latexmk

  Write-Host 'LaTeX setup successfully!'
}