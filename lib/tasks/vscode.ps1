Import-Module -DisableNameChecking $PSScriptRoot\..\"file-helpers.psm1"

Task vscode {
  Write-Host "Setting up VS Code config ... "

  $config_dir = "$env:AppData\Code\User"

  EnsurePath $config_dir

  $vscode_config | Out-File -FilePath "$config_dir\settings.json"

  Write-Host "Successfully setup VS Code config."
}

$vscode_config = @"
'editor.tabSize' => 2,
'explorer.confirmDragAndDrop' => false,
'files.trimTrailingWhitespace': true,
'files.exclude' => {
  '**/.classpath' => true,
  '**/.project' => true,
  '**/.settings' => true,
  '**/.factorypath' => true,
  '**/*.aux' => true,
  '**/*.fdb_latexmk' => true,
  '**/*.fls' => true,
  '**/*.gz' => true,
  '**/*.out' => true,
  '**/*.lb' => true,
  '**/*.log' => true,
  '**/*.synctex*' => true,
  '**/*.bbl' => true,
  '**/*.bcf' => true,
  '**/*.blg' => true,
  '**/*.run.xml' => true,
  '**/*.xdv' => true,
  '**/*.nav' => true,
  '**/*.snm' => true,
  '**/*.toc' => true,
  '**/*.gummi' => true
},
'[latex]' => {
  'editor.wordWrap' => 'on'
},
'workbench.colorTheme' => 'Community Material Theme Darker',
'workbench.iconTheme' => 'material-icon-theme',
'powershell.integratedConsole.showOnStartup' => false,
'rust-analyzer.inlayHints.enable' => false
}
"@