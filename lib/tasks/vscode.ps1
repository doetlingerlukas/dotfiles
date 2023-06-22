Import-Module -DisableNameChecking $PSScriptRoot\..\"file-helpers.psm1"

Task vscode {
  Write-Host "Setting up VS Code ... "

  $config_dir = "$env:AppData\Code\User"

  EnsurePath $config_dir

  $vscode_config | Out-File -FilePath "$config_dir\settings.json"

  # Install extensions.
  @(
    '13xforever.language-x86-64-assembly',
    'ban.spellright',
    'bungcip.better-toml',
    'compulim.indent4to2',
    'davidanson.vscode-markdownlint',
    'equinusocio.vsc-material-theme',
    'geekidos.vdf',
    'github.vscode-github-actions',
    'github.vscode-pull-request-github',
    'ionutvmi.reg',
    'james-yu.latex-workshop',
    'ms-azure-devops.azure-pipelines',
    'ms-azuretools.vscode-docker',
    'ms-kubernetes-tools.vscode-kubernetes-tools',
    'ms-python.python',
    'ms-toolsai.jupyter',
    'ms-vscode-remote.remote-containers',
    'ms-vscode-remote.remote-wsl',
    'ms-vscode.azure-account',
    'ms-vscode.cpptools',
    'ms-vscode.powershell',
    'ms-vsliveshare.vsliveshare',
    'pivotal.vscode-concourse',
    'pivotal.vscode-manifest-yaml',
    'pkief.material-icon-theme',
    'rebornix.ruby',
    'rust-lang.rust-analyzer',
    'serayuzgur.crates',
    'twxs.cmake',
    'tyriar.sort-lines',
    'visualstudioexptteam.vscodeintellicode',
    'vscjava.vscode-java-pack',
    'wingrunr21.vscode-ruby',
    'xoronic.pestfile'
  ) | foreach {
    Exec { code --install-extension $_ }
  }

  Write-Host "Successfully setup VS Code."
}

$vscode_config = @"
{
  "editor.tabSize": 2,
  "explorer.confirmDragAndDrop": false,
  "files.trimTrailingWhitespace": true,
  "files.exclude": {
    "**/.classpath": true,
    "**/.project": true,
    "**/.settings": true,
    "**/.factorypath": true,
    "**/*.aux": true,
    "**/*.fdb_latexmk": true,
    "**/*.fls": true,
    "**/*.gz": true,
    "**/*.out": true,
    "**/*.lb": true,
    "**/*.log": true,
    "**/*.synctex*": true,
    "**/*.bbl": true,
    "**/*.bcf": true,
    "**/*.blg": true,
    "**/*.run.xml": true,
    "**/*.xdv": true,
    "**/*.nav": true,
    "**/*.snm": true,
    "**/*.toc": true,
    "**/*.gummi": true
  },
  "[latex]": {
    "editor.wordWrap": "on"
  },
  "latex-workshop.view.pdf.viewer": "browser",
  "workbench.colorTheme": "Community Material Theme Darker",
  "workbench.iconTheme": "material-icon-theme",
  "powershell.integratedConsole.showOnStartup": false,
  "terminal.integrated.profiles.windows": {
    "pwsh": {
      "path": "$((Get-Command pwsh).Path -replace '\\','\\')",
      "args": []
    }
  },
  "terminal.integrated.defaultProfile.windows": "pwsh",
  "terminal.integrated.fontFamily": "Cousine NF",
  "explorer.confirmDelete": false,
  "rust-analyzer.inlayHints.enable": false
}
"@