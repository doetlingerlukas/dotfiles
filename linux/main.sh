#!/bin/bash

execute_configs () {
  for file in ./configs/*.sh; do
    bash "$file" -H
  done 
}

execute_configs