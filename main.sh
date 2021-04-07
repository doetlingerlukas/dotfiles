#!/bin/bash

# Abort on errors.
set -eo pipefail

echo "Updating system ..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Linuxbrew.
if ! type "brew" &> /dev/null
then
  echo -e "\e[30;103mInstalling Linuxbrew ...\e[0m"
  sudo apt-get install build-essential procps curl file git -y

  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
fi

# Install Ruby.
if ! type "ruby" &> /dev/null
then
  echo -e "\e[30;103mNo ruby installation found!\e[0m"
  brew install ruby
fi
if ! type "rake" &> /dev/null
then
  gem install rake
fi

echo "Installing necessary ruby gems ..."
gem install os
gem install vdf
gem install down

rake linux