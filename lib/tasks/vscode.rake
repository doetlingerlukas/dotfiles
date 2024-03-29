# frozen_string_literal: true

require 'json'
require 'os'
require 'command'
require 'which'
require 'distro'

task :vscode => [:'vscode:extensions', :'vscode:config']

namespace :vscode do
  desc 'setup config file for VS Code'
  task :config do

    puts 'Writing config file for VS Code.'

    config_dir = OS.windows? ?
      "C:/Users/#{ENV['USERNAME']}/AppData/Roaming/Code/User" :
      "#{ENV['HOME']}/.config/Code/User"

    FileUtils.mkdir_p config_dir

    config_raw = {
      'editor.tabSize' => 2,
      'explorer.confirmDragAndDrop' => false,
      'files.trimTrailingWhitespace': true,
      'files.exclude' => {
        '**/.classpath' => true,
        '**/.project' => true,
        '**/.settings' => true,
        '**/.factorypath' => true,
        '**/*.aux' => true,
        '**/*.fdb_latexmk' => true,
        '**/*.fls' => true,
        '**/*.gz' => true,
        '**/*.out' => true,
        '**/*.lb' => true,
        '**/*.log' => true,
        '**/*.synctex*' => true,
        '**/*.bbl' => true,
        '**/*.bcf' => true,
        '**/*.blg' => true,
        '**/*.run.xml' => true,
        '**/*.xdv' => true,
        '**/*.nav' => true,
        '**/*.snm' => true,
        '**/*.toc' => true,
        '**/*.gummi' => true
      },
      '[latex]' => {
        'editor.wordWrap' => 'on'
      },
      'workbench.colorTheme' => 'Community Material Theme Darker',
      'workbench.iconTheme' => 'material-icon-theme',
      'powershell.integratedConsole.showOnStartup' => false,
      'rust-analyzer.inlayHints.enable' => false
    }

    if OS.windows?
      config_raw['terminal.integrated.profiles.windows'] = {
        'pwsh' => {
          'path' => (which 'pwsh'),
          'args' => []
        }
      }
      config_raw['terminal.integrated.defaultProfile.windows'] = 'pwsh'
      config_raw['terminal.integrated.fontFamily'] = 'Cousine NF'
    end

    File.write "#{config_dir}/settings.json", JSON.pretty_generate(config_raw)
  end

  desc 'install extensions for VS Code'
  task :extensions do
    next if wsl?

    puts 'Installing VS Code extensions.'

    [
      'visualstudioexptteam.vscodeintellicode',
      'ms-vscode.powershell',
      'ms-vscode.cpptools',
      'ms-vscode-remote.remote-wsl',
      'ms-vscode.azure-account',
      'ms-vscode-remote.remote-containers',
      'ms-vsliveshare.vsliveshare',
      'ms-azuretools.vscode-docker',
      'ms-azure-devops.azure-pipelines',
      'ms-kubernetes-tools.vscode-kubernetes-tools',
      'ms-toolsai.jupyter',
      'ms-python.python',
      'vscjava.vscode-java-pack',
      'github.vscode-pull-request-github',
      'pivotal.vscode-manifest-yaml',
      'pivotal.vscode-concourse',
      'rebornix.ruby',
      'wingrunr21.vscode-ruby',
      'xoronic.pestfile',
      'bungcip.better-toml',
      'serayuzgur.crates',
      'pkief.material-icon-theme',
      'equinusocio.vsc-material-theme',
      'james-yu.latex-workshop',
      'compulim.indent4to2',
      'geekidos.vdf',
      '13xforever.language-x86-64-assembly',
      'twxs.cmake',
      'ban.spellright',
      'tyriar.sort-lines',
      'davidanson.vscode-markdownlint',
      'matklad.rust-analyzer'
    ].each do |e|
      command 'code', '--install-extension', e
    end

  end
end