param(
  [string]$mode="setup"
)

Function executedConfigs () {
  Get-ChildItem -Filter '*.ps1' '.\configs\' | ForEach-Object {
    & $_.FullName
  }
}

switch ($mode) {
  "config" {
    Invoke-Expression executedConfigs
    break
  }
  "setup" {
    & .\programs.ps1
    Invoke-Expression executedConfigs
    break
  }
}

"Restarting in 30 seconds ..."
Start-Sleep 30
Restart-Computer