#!/bin/bash

echo "Installing apt packages ..."

apt_packages="
  snap,
  default-jdk,
  p7zip-full p7zip-rar,
  git,
  python3,
  python3-pip
  "

for package in ${apt_packages//,/ }; do
  sudo apt install $package -y
done

echo "Installing snaps ..."

snaps="
  code --classic,
  telegram-desktop,
  postman,
  firefox,
  powershell --classic,
  gitkraken,
  node --channel=10/stable --classic
  "

for snap in ${snaps//,/ }; do
  sudo snap install $snap 
done