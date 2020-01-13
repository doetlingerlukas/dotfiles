# frozen_string_literal: true

require 'open3'

def laptop?
  stdout, stderr, status = Open3.capture3("powershell", "-command", "Write-Host $env:computername")
  stdout.downcase.include?("razer")
end