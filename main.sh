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
    rake ${file##*/}
  done 
}

if [ "${MODE}" == "config" ]
then
  echo -e "\e[30;103mStarting dotfiles in configuration mode ...\e[0m"
  execute_tasks
else 
  echo -e "\e[30;42mStarting dotfiles in setup mode ...\e[0m"

  echo "Updating system ..."
  sudo apt update
  sudo apt upgrade -y

  sudo apt install ruby -y

  bash ./installs.sh -H
  execute_tasks
fi
