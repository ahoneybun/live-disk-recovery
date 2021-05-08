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
echo "NOTE: For Ubuntu is would be the 2nd and for Pop!_OS it would be the 3rd"

echo ""

read -p 'What drive has your OS? ' drivevar
read -p 'What is the root partition? ' rootvar

#read -p 'What is the EFI partition? ' efivar
efivar=$(lsblk -if | grep EFI | awk -F- {'print$2'}  | awk {'print "/dev/"$1'})
read -p 'What is your OS? ' osvar
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
### Ubuntu section
​
    elif [[ $drivevar = nvme && $osvar = ubuntu && $encryptvar = yes ]]
        then
            sudo cryptsetup luksOpen $rootvar cryptdata
            sudo lvscan
            sudo vgchange -ay
            sudo mount /dev/mapper/vgubuntu-root /mnt
            sudo mount $efivar /mnt/boot/efi
            for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
            sudo cp /etc/resolv.conf /mnt/etc/
            sudo chroot /mnt
    elif [[ $drivevar = sata && $osvar = ubuntu && $encryptvar = yes ]]
        then
            sudo cryptsetup luksOpen /dev/$rootvar cryptdata
            sudo lvscan
            sudo vgchange -ay
            sudo mount /dev/mapper/vgubuntu-root /mnt
            sudo mount $efivar /mnt/boot/efi
            for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
            sudo cp /etc/resolv.conf /mnt/etc/
            sudo chroot /mnt
    elif [[ $drivevar = nvme && $osvar = ubuntu && $encryptvar = no ]]
        then
            sudo mount $rootvar /mnt
            sudo mount $efivar /mnt/boot/efi
            for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
            sudo cp /etc/resolv.conf /mnt/etc/
            sudo chroot /mnt
    elif [[ $drivevar = sata && $osvar = ubuntu && $encryptvar = no ]]
        then
            sudo mount $rootvar /mnt
            sudo mount $efivar /mnt/boot/efi
            for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
            sudo cp /etc/resolv.conf /mnt/etc/
            sudo chroot /mnt
fi

