# frozen_string_literal: true

require 'os'
require 'open3'

def is_distro?(common_name)
  return false unless OS.linux?
  out, _, status = Open3.capture3('cat', '/etc/lsb-release')
  out.include? common_name
end

def ubuntu?
  is_distro? 'ubuntu'
end

def elementary?
  is_distro? 'elementary'
end