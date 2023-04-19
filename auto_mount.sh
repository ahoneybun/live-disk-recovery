#!/usr/bin/env bash

# Set append for drive automation
APPEND=""

# Pop function
pop-encrypt-fn() {
   sudo cryptsetup luksOpen $rootName cryptdata
   sudo lvscan
   sudo vgchange -ay
   sudo mount /dev/mapper/data-root /mnt
   sudo mount $efiName /mnt/boot/efi
   for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
   sudo cp /etc/resolv.conf /mnt/etc/
   sudo chroot /mnt
}

pop-fn() {
   sudo mount $rootName /mnt
   sudo mount $efiName /mnt/boot/efi
   for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
   sudo cp /etc/resolv.conf /mnt/etc/
   sudo chroot /mnt
}

# NixOS function
nix-encrypt-fn() {
   sudo cryptsetup luksOpen $rootName crypt-root
   sudo lvscan
   sudo vgchange -ay
   sudo mount /dev/mapper/lvm-root /mnt
   sudo mount $efiName /mnt/@root/boot/
   sudo mount -o bind /dev /mnt/@root/dev
   sudo mount -o bind /proc /mnt/@root/proc
   sudo mount -o bind /sys /mnt/@root/sys
   sudo cp /etc/resolv.conf /mnt/@root/etc/
   sudo chroot /mnt/@root /nix/var/nix/profiles/system/activate
   sudo chroot /mnt/@root /run/current-system/sw/bin/bash
}

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

if [[ "$drivevar" = "/dev/nvme"* || "$drivevar" = "/dev/mmcblk0"* ]]; then
  APPEND="p"
fi

efiName=${drivevar}${APPEND}1
rootName=${drivevar}${APPEND}2
swapName=${drivevar}${APPEND}4

read -p 'Is your drive encrypted? ' encryptvar

if [[ $distro = "Pop!_OS 22.04 LTS" && $encryptvar = yes ]]; then
   echo "I am Pop and I'm encrypted"
   echo "Your EFI partition is" $efiName
   echo "Your root partition is" $rootName
#   pop-encrypt-fn

elif [[ $distro = "Pop!_OS 22.04 LTS" && $encryptvar = no ]]; then
   echo "I am Pop and I am not encrypted"

elif [[ $distro = "NixOS 22.11 (Raccoon)" && $encryptvar = yes ]]; then
   echo "I am NixOS and I'm encrypted"
   echo "Your EFI partition is" $efiName
   echo "Your root partition is" $rootName
#   nix-encrypt-fn
fi

# Ubuntu section
## sudo mount /dev/mapper/vgubuntu-root /mnt

# Fedora section
## sudo mount /dev/mapper/vgubuntu-root /mnt

## Nobara section

### sudo mount /dev/mapper/nobara_localhost--live-root /mnt
### sudo mount /dev/mapper/nobara_localhost--live-home /mnt/home

