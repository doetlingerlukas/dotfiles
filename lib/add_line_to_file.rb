# frozen_string_literal: true

require 'command'

def add_line_to_file(file, line)
  file = File.expand_path(file)

  if File.exist?(file)
    lines = File.readlines(file).map(&:strip)
    return if lines.include?(line)
  else
    FileUtils.mkdir_p File.dirname(file)
    FileUtils.touch file
  end

  command 'echo', line, '|', 'sudo', 'tee', '-a', file
end