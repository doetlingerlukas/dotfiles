# frozen_string_literal: true

require 'open3'

task :git do 
  puts "Setting up git config ..."

  Open3.capture3("powershell", "-command", "git config --global user.name 'Lukas Dötlinger'")
  Open3.capture3("powershell", "-command", "git config --global user.email 'lukas.doetlinger@student.uibk.ac.at'")
end