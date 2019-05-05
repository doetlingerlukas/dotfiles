"Setting up Visual Studio Code config ..."

$config_dir = "C:\Users\" + $env:USERNAME + "\AppData\Roaming\Code\User"

$settings = @" 
{
  "editor.tabSize": 2,
  "explorer.confirmDragAndDrop": false,
  "files.exclude": {
      "**/.classpath": true,
      "**/.project": true,
      "**/.settings": true,
      "**/.factorypath": true
  }
}
"@

$settings | ConvertTo-Json -Depth 10 | Out-File -Encoding "ASCII" ($config_dir + "\settings.json")