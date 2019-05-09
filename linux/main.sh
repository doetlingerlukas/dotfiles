#!/bin/bash

echo "Updating system ..."
sudo apt update
sudo apt upgrade -y

execute_configs () {
  for file in ./configs/*.sh; do
    bash "$file" -H
  done 
}

execute_configs