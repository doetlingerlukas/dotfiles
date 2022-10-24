Task git {
  Write-Host "Setting up Git config ..."

  Exec { git --version } "Error, Git is not available."

  git config --global user.name 'Lukas Dötlinger'
  git config --global user.email 'lukas@doetlinger.at'

  git config --global init.defaultBranch 'main'

  # Use VSCode as editor
  git config --global core.editor 'code --wait'

  # Short aliases for common commands
  git config --global alias.cl 'clone'
  git config --global alias.ci 'commit'
  git config --global alias.co 'checkout'
  git config --global alias.st 'status -s'
  git config --global alias.d 'diff'
  git config --global alias.r 'reset'
  git config --global alias.rh 'reset --hard'

  # Aliases for lisitng
  git config --global alias.tags 'tag -l'
  git config --global alias.branches 'branch -a'
  git config --global alias.remotes 'remote -v'

  # Display current branch
  git config --global alias.currentBranch "!git branch --contains HEAD | grep '*' | tr -s ' ' | cut -d ' ' -f2"

  # Show all aliases
  git config --global alias.aliases 'config --get-regexp ^alias\.'

  # Set global .gitignore
  $gitignore_global = "$env:USERPROFILE\.gitignore_global"
  git config --global core.excludesfile $gitignore_global

  $gitignore_config = Out-File -FilePath $gitignore_global

  Write-Host 'Git config setup successfully!'
}

$gitignore_config =   @"
.idea/
.vscode/

npm-debug.log*
yarn-debug.log*
yarn-error.log*

.classpath
.project
.settings
.factorypath
*.aux
*.fdb_latexmk
*.fls
*.gz
*.out
*.lb
*.log
*.synctex*
*.bbl
*.bcf
*.blg
*.run.xml
*.xdv
*.nav
*.snm
*.toc
*.gummi
"@
