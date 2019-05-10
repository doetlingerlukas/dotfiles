#!/bin/bash

echo "Installing fish shell ..."
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish -y

echo "Configuring fish to be the default shell ..."
chsh -s /usr/local/bin/fish
echo /usr/local/bin/fish | sudo tee -a /etc/shells