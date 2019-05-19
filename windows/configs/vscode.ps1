"Setting up Visual Studio Code config ..."

$config_dir = "C:\Users\" + $env:USERNAME + "\AppData\Roaming\Code\User"

$settings = @" 
{
  "editor.tabSize": "2",
  "explorer.confirmDragAndDrop": false,
  "files.exclude": {
      "**/.classpath": true,
      "**/.project": true,
      "**/.settings": true,
      "**/.factorypath": true
  }
}
"@ | ConvertFrom-Json

if ((Get-WmiObject -Class:Win32_ComputerSystem).Model -eq "Blade Stealth") {
  $settings | Add-Member -Name "window.zoomLevel" -Value ([convert]::ToInt32(-1, 10)) -MemberType NoteProperty
}

$settings | ConvertTo-Json -Depth 5 | Out-File -Encoding "ASCII" ($config_dir + "\settings.json")