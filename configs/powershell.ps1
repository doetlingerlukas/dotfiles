"Configuring Powershell ..."

New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR | Out-Null

# Creates a menue item in Explorer to open the powershell as Admin on the current path.
Function setupOpenPowershellHere() {
  $menu = 'Open Windows PowerShell Here as Administrator'
  $command = "$PSHOME\powershell.exe -NoExit -NoProfile -Command ""Set-Location '%V'"""
 
  'directory', 'directory\background', 'drive' | ForEach-Object {
    New-Item -Path "HKCR:\$_\shell" -Name runas\command -Force |
    Set-ItemProperty -Name '(default)' -Value $command -PassThru |
    Set-ItemProperty -Path {$_.PSParentPath} -Name '(default)' -Value $menu -PassThru |
    Set-ItemProperty -Name 'HasLUAShield' -Value '' -PassThru |
    Set-ItemProperty -Name 'Icon' -Value 'powershell.exe'
  }
}

Invoke-Expression setupOpenPowershellHere