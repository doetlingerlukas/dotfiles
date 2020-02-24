# frozen_string_literal: true

def which(executable)
  ENV['PATH']
    .split(File::PATH_SEPARATOR)
    .map { |path| "#{path}/#{executable}" }
    .detect { |path| File.executable?(path) }
end