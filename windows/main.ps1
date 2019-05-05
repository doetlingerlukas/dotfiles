param(
  [string]$mode="setup"
)

Function executeConfigs () {
  Get-ChildItem -Filter '*.ps1' '.\configs\' | ForEach-Object {
    & $_.FullName
  }
}

switch ($mode) {
  "config" {
    Invoke-Expression executeConfigs
    break
  }
  "setup" {
    & .\programs.ps1
    Invoke-Expression executeConfigs
    break
  }
}

"Restarting in 30 seconds ..."
Start-Sleep 30
Restart-Computer