# frozen_string_literal: true

require 'command'

task :git do 
  puts 'Setting up git config ...'

  command 'git', 'config', '--global', 'user.name', 'Lukas Dötlinger'
  command 'git', 'config', '--global', 'user.email', 'lukas.doetlinger@student.uibk.ac.at'
end
