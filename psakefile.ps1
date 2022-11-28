Get-ChildItem -Filter '*.ps1' '.\lib\tasks\' | ForEach-Object {
  Write-Host "Including " + $_.FullName
  Include $_.FullName
}

Task default -Depends setup

Task setup -Depends uninstalls, installs, configs {}

Task configs -Depends csgo, explorer, git, latex, nvm, pwsh, ssh, steam, terminal, vscode, windows {}
