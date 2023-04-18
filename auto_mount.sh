#!/bin/bash

# Set append for drive automation
APPEND=""

clear
echo "-------------------------------------------------------------------------------"
echo " A tool to mount an installed OS from a live disk for repair or data recovery |" 
distro="$(cat /etc/os-release | awk -F "\"" '/PRETTY_NAME/ {print $2}')"
echo "-------------------------------------------------------------------------------"
sleep 2
clear

echo "-------------------------------------------------------------------------------"
lsblk -f
echo "-------------------------------------------------------------------------------"

read -p 'Which drive has your OS? ' drivevar

if [[ "$drivevar" == "/dev/nvme"* || "$drivevar" == "/dev/mmcblk0"* ]]; then
  APPEND="p"
fi

efiName=${driveName}$APPEND
efiName+=1
rootName=${driveName}$APPEND
rootName+=3
swapName=${driveName}$APPEND
swapName+=4

if [[ $distro = "Pop!_OS 22.04 LTS" ]]; then
   echo "I am Pop"
   echo "Your EFI partition is" $efiName
   echo "Your root partition is" $rootName
fi

#read -p 'What is the root partition? ' rootvar
#read -p 'What is the EFI partition? ' efivar
#efivar=$(lsblk -if | grep EFI | awk -F- {'print$2'}  | awk {'print "/dev/"$1'})

read -p 'Is your drive encrypted? ' encryptvar

### Pop section

if [[ $drivevar = nvme && $osvar = pop && $encryptvar = yes ]]
    then
        sudo cryptsetup luksOpen $rootvar cryptdata
        sudo lvscan
        sudo vgchange -ay
        sudo mount /dev/mapper/data-root /mnt
        sudo mount $efivar /mnt/boot/efi
        for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
        sudo cp /etc/resolv.conf /mnt/etc/
        sudo chroot /mnt
    elif [[ $drivevar = sata && $osvar = pop && $encryptvar = yes ]]
        then
            sudo cryptsetup luksOpen $rootvar cryptdata
            sudo lvscan
            sudo vgchange -ay
            sudo mount /dev/mapper/data-root /mnt
            sudo mount $efivar /mnt/boot/efi
            for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
            sudo cp /etc/resolv.conf /mnt/etc/
            sudo chroot /mnt
    elif [[ $drivevar = nvme && $osvar = pop && $encryptvar = no ]]
        then
            sudo mount $rootvar /mnt
            sudo mount $efivar /mnt/boot/efi
            for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
            sudo cp /etc/resolv.conf /mnt/etc/
            sudo chroot /mnt
    elif [[ $drivevar = sata && $osvar = pop && $encryptvar = no ]]
        then
            sudo mount $rootvar /mnt
            sudo mount $efivar /mnt/boot/efi
            for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
            sudo cp /etc/resolv.conf /mnt/etc/
            sudo chroot /mnt
​
# Ubuntu section
## sudo mount /dev/mapper/vgubuntu-root /mnt

# Fedora section
## sudo mount /dev/mapper/vgubuntu-root /mnt

## Nobara section

### sudo mount /dev/mapper/nobara_localhost--live-root /mnt
### sudo mount /dev/mapper/nobara_localhost--live-home /mnt/home

