# frozen_string_literal: true

require 'os'
require 'command'
require 'which'

desc 'configure OpenSSH'
task :ssh do
  next unless OS.windows?

  pwsh 'Set-Service', 'ssh-agent', '-StartupType', 'Automatic'

  ssh_dir = "C:/Users/#{ENV['USERNAME']}/OneDrive/.ssh"
  if Dir.exist? ssh_dir then
    FileUtils.cp_r "#{ssh_dir}/.", "C:/Users/#{ENV['USERNAME']}/.ssh"
  end

  File.write "C:/Users/#{ENV['USERNAME']}/.ssh/config", <<~CFG
    Host github.com
      HostName github.com
      IdentityFile ~/.ssh/github_ed25519
  CFG

  # Use OpenSSH as agent for Git
  env_name = 'GIT_SSH'
  openssh_path = (which 'ssh')
  pwsh "[Environment]::SetEnvironmentVariable(\"#{env_name}\", \"#{openssh_path}\", [System.EnvironmentVariableTarget]::User)"
end
