# frozen_string_literal: true

require 'command'

task :git do 
  puts 'Setting up git config ...'

  pwsh 'git', 'config', '--global', 'user.name', 'Lukas Dötlinger'
  pwsh 'git', 'config', '--global', 'user.email', 'lukas.doetlinger@student.uibk.ac.at'
end
