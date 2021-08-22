# frozen_string_literal: true

require 'os'
require 'command'

desc 'configure OpenSSH'
task :ssh do
  next unless OS.windows?

  pwsh 'Set-Service', 'ssh-agent', '-StartupType', 'Automatic'

  ssh_dir = "C:/Users/#{ENV['USERNAME']}/OneDrive/.ssh"
  if Dir.exist? ssh_dir then
    FileUtils.cp_r "#{ssh_dir}/.", "C:/Users/#{ENV['USERNAME']}/.ssh"
  end
end
