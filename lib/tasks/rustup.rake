# frozen_string_literal: true

require 'os'
require 'open3'

desc 'installs rustup and tab complesion for fish shell'
task rustup: do
  next unless OS.linux?

  Open3.pipeline ['curl', '--proto', '\'=https\'', '--tlsv1.2', '-sSf', 'https://sh.rustup.rs'], ['sh']

  FileUtils.mkdir_p "#{ENV['HOME']}/.config/fish/completions"

  out, err, status = Open3.capture3 'rustup', 'completions', 'fish'
  File.write "#{ENV['HOME']}/.config/fish/completions/rustup.fish"
end