# frozen_string_literal: true

require 'command'

class ElevationError < StandardError
  def message
    'Elevated rights needed to execute this task!'
  end
end

def elevated?
  out = capture_pwsh "[Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'"
  raise ElevationError if out.downcase.include?('false')
end