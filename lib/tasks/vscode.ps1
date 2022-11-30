Import-Module -DisableNameChecking $PSScriptRoot\..\"file-helpers.psm1"

Task vscode {
  Write-Host "Setting up VS Code ... "

  $config_dir = "$env:AppData\Code\User"

  EnsurePath $config_dir

  $vscode_config | Out-File -FilePath "$config_dir\settings.json"

  # Install extensions.
  @(
    'visualstudioexptteam.vscodeintellicode',
    'ms-vscode.powershell',
    'ms-vscode.cpptools',
    'ms-vscode-remote.remote-wsl',
    'ms-vscode.azure-account',
    'ms-vscode-remote.remote-containers',
    'ms-vsliveshare.vsliveshare',
    'ms-azuretools.vscode-docker',
    'ms-azure-devops.azure-pipelines',
    'ms-kubernetes-tools.vscode-kubernetes-tools',
    'ms-toolsai.jupyter',
    'ms-python.python',
    'vscjava.vscode-java-pack',
    'github.vscode-pull-request-github',
    'pivotal.vscode-manifest-yaml',
    'pivotal.vscode-concourse',
    'rebornix.ruby',
    'wingrunr21.vscode-ruby',
    'xoronic.pestfile',
    'bungcip.better-toml',
    'serayuzgur.crates',
    'pkief.material-icon-theme',
    'equinusocio.vsc-material-theme',
    'james-yu.latex-workshop',
    'compulim.indent4to2',
    'geekidos.vdf',
    '13xforever.language-x86-64-assembly',
    'twxs.cmake',
    'ban.spellright',
    'tyriar.sort-lines',
    'davidanson.vscode-markdownlint',
    'rust-lang.rust-analyzer'
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