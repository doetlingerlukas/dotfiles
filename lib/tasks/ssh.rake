# frozen_string_literal: true

require 'os'
require 'command'

desc 'configure OpenSSH'
task :ssh do
  next unless OS.windows?

  pwsh 'Set-Service', 'ssh-agent', '-StartupType', 'Automatic'
end
