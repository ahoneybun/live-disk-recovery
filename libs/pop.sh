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
fi