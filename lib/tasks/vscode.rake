# frozen_string_literal: true

require 'json'
require 'os'
require 'laptop'
require 'command'
require 'which'

task :vscode => [:'vscode:extensions', :'vscode:config']

namespace :vscode do
  desc 'setup config file for VS Code'
  task :config do

    puts 'Writing config file for VS Code.'

    config_dir = OS.windows? ?
      "C:/Users/#{ENV['USERNAME']}/AppData/Roaming/Code/User" :
      "#{ENV['HOME']}/.config/Code/User"

    puts 'Debug 1'

    FileUtils.mkdir_p config_dir

    puts 'Debug 2'

    config_raw = {
      'editor.tabSize' => 2,
      'explorer.confirmDragAndDrop' => false,
      'files.exclude' => {
        '**/.classpath' => true,
        '**/.project' => true,
        '**/.settings' => true,
        '**/.factorypath' => true,
        '**/*.aux' => true,
        '**/*.fdb_latexmk' => true,
        '**/*.fls' => true,
        '**/*.gz' => true,
      },
      'workbench.colorTheme' => 'Community Material Theme Darker',
      'workbench.iconTheme' => 'material-icon-theme'
    }

    puts 'Debug 3'

    if OS.windows?
      config_raw['terminal.integrated.shell.windows'] = (which 'pwsh.exe')
      config_raw['terminal.integrated.fontFamily'] = "'Cousine NF'"
    end

    puts 'Debug 4'

    if laptop?
      config_raw['window.zoomLevel'] = '-1'
    end

    puts 'Debug 5'

    File.write "#{config_dir}/settings.json", JSON.pretty_generate(config_raw)

    puts 'Debug 6'
  end

  desc 'install extensions for VS Code'
  task :extensions do

    puts 'Installing VS Code extensions.'

    [
      'ms-vscode.powershell',
      'ms-vscode.cpptools',
      'pivotal.vscode-manifest-yaml',
      'pivotal.vscode-concourse',
      'ms-vsliveshare.vsliveshare',
      'ms-azuretools.vscode-docker',
      'rebornix.ruby',
      'visualstudioexptteam.vscodeintellicode',
      'wingrunr21.vscode-ruby',
      'xoronic.pestfile',
      'rust-lang.rust',
      'bungcip.better-toml',
      'serayuzgur.crates',
      'pkief.material-icon-theme',
      'equinusocio.vsc-material-theme',
      'james-yu.latex-workshop',
      'compulim.indent4to2',
      'ms-azure-devops.azure-pipelines',
      'geekidos.vdf',
      '13xforever.language-x86-64-assembly'
    ].each do |e|
      command 'code', '--install-extension', e
    end

  end
end