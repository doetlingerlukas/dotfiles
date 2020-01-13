# frozen_string_literal: true

require 'json'
require 'laptop'
require 'open3'

namespace :vscode do
  desc "Setup config file."
  task :config do
    
    puts "Writing config file for VS Code."
    config_dir = "C:/Users/#{ENV['USERNAME']}/AppData/Roaming/Code/User"

    FileUtils.mkdir_p config_dir

    config_raw = {
      "editor.tabSize" => "2",
      "explorer.confirmDragAndDrop" => "false",
      "files.exclude" => {
        "**/.classpath" => "true",
        "**/.project" => "true",
        "**/.settings" => "true",
        "**/.factorypath" => "true"
      }
    }

    if laptop?
      config_raw["window.zoomLevel"] = "-1"
    end

    File.write "#{config_dir}/settings.json", JSON.pretty_generate(config_raw)

  end

  desc "Install extensions."
  task :extensions do

    puts "Installing VS Code extensions."

    [
      "ms-vscode.powershell",
      "ms-vscode.cpptools",
      "pivotal.vscode-manifest-yaml",
      "pivotal.vscode-concourse",
      "ms-azuretools.vscode-docker",
      "rebornix.ruby",
      "visualstudioexptteam.vscodeintellicode",
      "wingrunr21.vscode-ruby"
    ].each do |e|
      stdout, stderr, status = Open3.capture3("powershell", "-command", "code --install-extension #{e}")
      if status.success?
        puts "Installed VS Code extension #{e}."
      else
        puts "Failed installing VS Code extension #{e}"
      end
    end

  end
end