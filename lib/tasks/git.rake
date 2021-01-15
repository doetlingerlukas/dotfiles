# frozen_string_literal: true

require 'command'
require 'os'

desc 'setup git config'
task :git do
  puts 'Setting up git config ...'

  command 'git', 'config', '--global', 'user.name', 'Lukas Dötlinger'
  command 'git', 'config', '--global', 'user.email', 'lukas.doetlinger@student.uibk.ac.at'

  command 'git', 'config', '--global', 'init.defaultBranch', 'main'

  # Use VSCode as editor.
  command 'git', 'config', '--global', 'core.editor', 'code --wait'

  # Short aliases for common commands
  command 'git', 'config', '--global', 'alias.cl', 'clone'
  command 'git', 'config', '--global', 'alias.ci', 'commit'
  command 'git', 'config', '--global', 'alias.co', 'checkout'
  command 'git', 'config', '--global', 'alias.st', 'status -s'
  command 'git', 'config', '--global', 'alias.d', 'diff'
  command 'git', 'config', '--global', 'alias.r', 'reset'
  command 'git', 'config', '--global', 'alias.rh', 'reset --hard'

  # Aliases for lisitng.
  command 'git', 'config', '--global', 'alias.tags', 'tag -l'
  command 'git', 'config', '--global', 'alias.branches', 'branch -a'
  command 'git', 'config', '--global', 'alias.remotes', 'remote -v'

  # Display current branch.
  command 'git', 'config', '--global', 'alias.currentBranch', "!git branch --contains HEAD | grep '*' | tr -s ' ' | cut -d ' ' -f2"
  
  # Show all aliases.
  command 'git', 'config', '--global', 'alias.aliases', 'config --get-regexp ^alias\.'
end
