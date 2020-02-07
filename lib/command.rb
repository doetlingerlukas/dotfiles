# frozen_string_literal: true

require 'open3'

def ps_command(command)
  stdout, stderr, status = Open3.capture3("powershell", "-command", "#{command}")
  return stdout, stderr, status
end