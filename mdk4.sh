#!/bin/bash -e 

sudo apt update && \
  sudo apt upgrade -y &&  

  echo "Successfully updated repo - proceeding..." 

{ sudo apt install mdk4 -y && echo "SUCCESS!"; } || { echo "error - failed to install mdk4" && exit 1; } 
