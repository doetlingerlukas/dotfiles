# frozen_string_literal: true

require 'command'
require 'os'

task :latex do
  next unless OS.windows? && !ENV['CI']

  puts 'Configuring LaTeX installation ...'

  command 'mpm', '--update'

  command 'mpm', '--install=latexmk'
end