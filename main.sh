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

verify_brew_installation () {
  brew_path=`which brew`
  if ! [[ "$brew_path" == *brew ]]
  then
    sudo apt install build-essential curl file git -y
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
  fi
}

verify_ruby_installation () {
  ruby_path=`which ruby`
  if ! [[ "$ruby_path" == *ruby ]]
  then
    brew install ruby
  fi
  rake_path=`which rake`
  if ! [[ "$rake_path" == *rake ]]
  then
    sudo gem install rake
  fi
}

# Abort on errors
set -e

verify_brew_installation
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
