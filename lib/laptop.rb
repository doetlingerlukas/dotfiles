# frozen_string_literal: true

require 'open3'
require 'os'

def laptop?
  if OS.windows?
    stdout, _, status = Open3.capture3("powershell", "-command", "Write-Host $env:computername")
    stdout.downcase.include?('razer')
  else
    ENV['HOSTNAME'].downcase.include?('razer')
  end
end