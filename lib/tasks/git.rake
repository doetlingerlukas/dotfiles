# frozen_string_literal: true

task :git do 
  puts 'Setting up git config ...'

  sh 'git', 'config', '--global', 'user.name', 'Lukas Dötlinger'
  sh 'git', 'config', '--global', 'user.email', 'lukas.doetlinger@student.uibk.ac.at'
end
