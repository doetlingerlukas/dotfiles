# frozen_string_literal: true

def which(executable)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']

  ENV['PATH']
    .split(File::PATH_SEPARATOR).each do |path|
      exts.each do |ext|
        exe = File.join(path, "#{executable}#{ext}")
        return exe if File.executable?(exe) && !File.directory?(exe)
      end
    end
  nil
end