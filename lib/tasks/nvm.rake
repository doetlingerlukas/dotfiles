# frozen_string_literal: true

require 'os'

task :nvm do
  next unless Os.windows?

    sh 'nvm', 'install', '12.13.0'
    sh 'nvm', 'install', '14.15.1'
    sh 'nvm', 'install', 'latest'

    sh 'nvm', 'use', '14.15.1'

  end
end