# frozen_string_literal: true

require 'open3'
require 'os'
require 'command'

def laptop?
  if OS.windows?
    out, _, status = ps_command('Write-Host $env:computername')
    out.downcase.include?('razer')
  else
    ENV['HOSTNAME'].downcase.include?('razer')
  end
end