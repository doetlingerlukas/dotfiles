# frozen_string_literal: true

require 'command'
require 'os'

task :nvm do
  next unless OS.windows?

  command 'nvm', 'install', '12.13.0'
  command 'nvm', 'install', '14.15.1'
  command 'nvm', 'install', 'latest'
  
  command 'nvm', 'use', '14.15.1'
end