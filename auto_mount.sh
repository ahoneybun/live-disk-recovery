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
lsblk -f
echo "-------------------------------------------------------------------------------"

echo ""

read -p 'What drive has your OS? ' drivevar

read -p 'What is the root partition? ' rootvar

read -p 'Is your drive encrypted? ' encryptvar

# Read -p 'What is the EFI partition? ' efivar
efivar=$(lsblk -if | grep EFI | awk -F- {'print$2'}  | awk {'print "/dev/"$1'})

if [[  $encryptvar = yes ]]
   then
      sudo cryptsetup luksOpen $rootvar crypt-root
      sudo lvscan
      sudo vgchange -ay
      sudo mount /dev/mapper/crypt-root /mnt
      sudo mount $efivar /mnt/boot/efi
      sudo cp /etc/resolv.conf /mnt/etc/
      cd /mnt
      sudo mount -t proc /proc proc/
      sudo mount -t sysfs /sys sys/
      sudo mount --rbind /dev dev/
      sudo chroot /mnt /bin/bash
elif [[ $encryptvar = no ]]
   then 
      sudo mount $rootvar /mnt
      sudo mount $efivar /mnt/boot/efi
      for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
      sudo cp /etc/resolv.conf /mnt/etc/
      sudo chroot /mnt
fi

# Pop section

if [[ $(grep PRETTY /mnt/etc/os-release | cut -c 13-) = *"Pop"* ]]; then
   echo "Pop!_OS detected"
​     libs/pop.sh

# Ubuntu section

elif [[ $(grep PRETTY /mnt/etc/os-release | cut -c 13-) = *"Ubuntu"* ]]; then
   echo "Ubuntu detected"
      libs/ubuntu.sh

# Arch section

elif [[ $(grep PRETTY /mnt/etc/os-release | cut -c 13-) = *"Arch Linux"* ]]; then
   echo "Arch detected"
      libs/arch.sh

fi
