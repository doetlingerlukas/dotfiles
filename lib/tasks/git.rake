# frozen_string_literal: true

require 'command'
require 'os'

desc 'setup git config'
task :git do
  puts 'Setting up git config ...'

  if OS.windows?
    FileUtils.cp("#{__dir__}/../../res/configs/.gitconfig", "C:/Users/#{ENV['USERNAME']}")    
  else
    pwsh 'git', 'config', '--global', 'user.name', 'Lukas Dötlinger'
    pwsh 'git', 'config', '--global', 'user.email', 'lukas.doetlinger@student.uibk.ac.at'
  end
end
