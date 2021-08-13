if [[ $drivevar = nvme && $encryptvar = yes ]]
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
    elif [[ $drivevar = sata && $encryptvar = yes ]]
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
    elif [[ $drivevar = nvme && $encryptvar = no ]]
        then
            sudo mount $rootvar /mnt
            sudo mount $efivar /mnt/boot/efi
            sudo cp /etc/resolv.conf /mnt/etc/
            cd /mnt
            sudo mount -t proc /proc proc/
            sudo mount -t sysfs /sys sys/
            sudo mount --rbind /dev dev/
            sudo chroot /mnt /bin/bash
    elif [[ $drivevar = sata && $encryptvar = no ]]
        then
            sudo mount $rootvar /mnt
            sudo mount $efivar /mnt/boot/efi
            sudo cp /etc/resolv.conf /mnt/etc/
            cd /mnt
            sudo mount -t proc /proc proc/
            sudo mount -t sysfs /sys sys/
            sudo mount --rbind /dev dev/
            sudo chroot /mnt /bin/bash
fi
