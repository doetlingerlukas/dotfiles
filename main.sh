#!/bin/bash

while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    -m|--mode)
      MODE="$2"
      shift
      shift
      ;;
  esac
done

execute_tasks () {
  for file in ./lib/tasks/*.rake; do
    basename=${file##*/}
    rake ${basename%.*}
  done 
}

verify_ruby_installation () {
  ruby_version=`ruby -v`
  if ! [[ "$ruby_version" =~ ^ruby ]]
  then
    sudo apt install ruby -y
  fi
  rake_version=`rake --version`
  if ! [[ "$rake_version" =~ ^rake ]]
  then
    sudo gem install rake
  fi
}

# Abort on errors
set -e

verify_ruby_installation

if [ "${MODE}" == "config" ]
then
  echo -e "\e[30;103mStarting dotfiles in configuration mode ...\e[0m"
  execute_tasks
else 
  echo -e "\e[30;42mStarting dotfiles in setup mode ...\e[0m"

  echo "Updating system ..."
  sudo apt update
  sudo apt upgrade -y

  sudo ruby ./res/installs.rb

  execute_tasks
fi
