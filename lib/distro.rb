# frozen_string_literal: true

require 'os'
require 'train'

def is_distro?(common_name)
  return nil unless OS.linux?
  dist_name = Train.create('local').connection.os[:name]
  dist_name.lowercase.include? common_name.lowercase
end

def ubuntu?
  is_distro? 'ubuntu'
end

def elementary?
  is_distro? 'elementary'
end