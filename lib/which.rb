# frozen_string_literal: true

require 'os'

def which(executable)
  ENV['PATH']
    .split(File::PATH_SEPARATOR)
    .map { |path|
      if OS.windows?
        "#{path}\\#{executable}"
      else
        "#{path}/#{executable}"
      end
    }
    .detect { |path| File.executable?(path) }
end