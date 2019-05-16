#!/bin/bash

echo "Installing fish shell ..."
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get install fish -y

echo "Configuring fish to be the default shell ..."
chsh -s $(which fish)
sudo usermod -s $(which fish) $(whoami)

if grep -Fxq $(which fish) /etc/shells 
then 
  # fish has already been added to shells
else
  # add fish to shells
  echo $(which fish) | sudo tee -a /etc/shells
fi