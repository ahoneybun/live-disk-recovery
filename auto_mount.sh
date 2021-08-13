#!/bin/bash
# Intro
# -------------
clear
echo "-------------------------------------------------------------------------------"
echo " A tool to mount an installed OS from a live disk for repair or data recovery |" 
distro="$(cat /etc/os-release | awk -F "\"" '/PRETTY_NAME/ {print $2}')"
echo "-------------------------------------------------------------------------------"
sleep 2
clear

# Setting username for OS logic
echo "-------------------------------------------------------------------------------"
lsblk
echo "-------------------------------------------------------------------------------"

echo ""

read -p 'What drive has your OS? ' drivevar

read -p 'What is the root partition? ' rootvar

# Read -p 'What is the EFI partition? ' efivar
efivar=$(lsblk -if | grep EFI | awk -F- {'print$2'}  | awk {'print "/dev/"$1'})
read -p 'Is your drive encrypted? ' encryptvar

# Pop section

if [[ $(grep PRETTY /etc/os-release | cut -c 13-) = *"Pop"* ]]; then
   echo "Pop!_OS detected"
​
## Run Pop!_OS bash script

libs/pop.sh

# Ubuntu section

elif [[ $(grep PRETTY /etc/os-release | cut -c 13-) = *"Ubuntu"* ]]; then
   echo "Ubuntu detected"

## Run Ubuntu bash script

libs/ubuntu.sh

# Arch section

elif [[ $(grep PRETTY /etc/os-release | cut -c 13-) = *"Arch Linux"* ]]; then
    echo "Arch detected"

## Run the Arch bash script

   lib/arch.sh

fi