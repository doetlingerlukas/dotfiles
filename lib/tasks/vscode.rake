# frozen_string_literal: true

require 'json'
require 'os'
require 'laptop'
require 'command'
require 'which'

task :vscode => [:'vscode:extensions', :'vscode:config']

namespace :vscode do
  desc 'Setup config file.'
  task :config do

    puts 'Writing config file for VS Code.'

    config_dir = OS.windows? ?
      "C:/Users/#{ENV['USERNAME']}/AppData/Roaming/Code/User" :
      "#{ENV['HOME']}/.config/Code/User"

    FileUtils.mkdir_p config_dir

    config_raw = {
      'editor.tabSize' => 2,
      'explorer.confirmDragAndDrop' => false,
      'files.exclude' => {
        '**/.classpath' => true,
        '**/.project' => true,
        '**/.settings' => true,
        '**/.factorypath' => true
      },
      'workbench.colorTheme' => 'Material Theme Darker',
      'workbench.iconTheme' => 'material-icon-theme'
    }

    if OS.windows?
      config_raw['terminal.integrated.shell.windows'] = (which 'pwsh.exe')
    end

    if laptop?
      config_raw['window.zoomLevel'] = '-1'
    end

    File.write "#{config_dir}/settings.json", JSON.pretty_generate(config_raw)

  end

  desc 'Install extensions.'
  task :extensions do

    puts 'Installing VS Code extensions.'

    [
      'ms-vscode.powershell',
      'ms-vscode.cpptools',
      'pivotal.vscode-manifest-yaml',
      'pivotal.vscode-concourse',
      'ms-azuretools.vscode-docker',
      'rebornix.ruby',
      'visualstudioexptteam.vscodeintellicode',
      'wingrunr21.vscode-ruby',
      'xoronic.pestfile',
      'rust-lang.rust',
      'bungcip.better-toml',
      'serayuzgur.crates',
      'pkief.material-icon-theme',
      'equinusocio.vsc-material-theme'
    ].each do |e|
      command 'code', '--install-extension', e
    end

  end
end