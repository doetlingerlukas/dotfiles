param(
  [string]$mode="setup"
)

if ($mode -eq "config") {
  # only run configs, instead of installing programs
  & .\configs\windows.ps1
  & .\configs\csgo.ps1
  & .\configs\battlefield5.ps1
} else {
  # install chocolatey and other programs
  & .\programs.ps1
}

"Restarting in 30 seconds ..."
Start-Sleep 30
Restart-Computer