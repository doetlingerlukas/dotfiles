# install chocolatey package manager 
"Installing chocolatey package manager ..."

if ($false -eq $(Test-Path -Path "$env:ProgramData\Chocolatey")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

"Finished installing chocolatey package manager!"

# install programms using chocolatey
"Installing packages ..."

ForEach($Package in  
  "adobereader", 
  "jdk8", 
  "jdk10", 
  "winrar", 
  "firefox",
  "googlechrome",
  "notepadplusplus.install", 
  "git.install", 
  "gitkraken",
  "nodejs.install", 
  "yarn",
  "python",
  "intellijidea-ultimate", 
  "vscode",
  "vscode-powershell",
  "postman",
  "telegram.install",
  "office365proplus",
  "virtualbox"
) {
    choco install $Package -y
}

"Finished installing packages!"