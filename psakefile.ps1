Get-ChildItem -Filter '*.ps1' '.\lib\tasks\' | ForEach-Object {
  Write-Host "Including " + $_.FullName
  Include $_.FullName
}

Task default -Depends setup

Task Init {

}

Task setup -Depends uninstalls, installs, configs {
  Write-Host "Test"
}

Task configs -Depends csgo, git, latex, nvm {

}