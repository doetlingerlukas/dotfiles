Get-ChildItem -Filter '*.ps1' '.\lib\tasks\' | ForEach-Object {
  Write-Host "Including " + $_.FullName
  Include $_.FullName
}

Task default -Depends Setup

Task Init {

}

Task Setup -Depends installs, csgo {
  Write-Host "Test"
}