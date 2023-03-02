# frozen_string_literal: true

require 'add_line_to_file'

desc 'configure wsl settings'
task :wsl do
  if ENV['WSL_DISTRO_NAME']
    add_line_to_file '/etc/wsl.conf', '[interop]'
    add_line_to_file '/etc/wsl.conf', 'appendWindowsPath=false'
  end
end
